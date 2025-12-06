import SwiftUI
import Combine
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - ScheduleViewModel

@MainActor
final class ScheduleViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var showFilterCircle: Bool = false
    @Published var scheduleList: [Сarrier] = []
    @Published var isLoading: Bool = false
    @Published var errorType: ErrorType?
    @Published var fromStationCode: String
    @Published var toStationCode: String
    @Published var fromStationName: String
    @Published var toStationName: String
    @Published var selectedDate: Date = Date()
    @Published var currentDepartureTimes: Set<Time> = [] {
        didSet {
            if currentDepartureTimes != oldValue {
                Task { await loadSchedule() }
            }
        }
    }
    @Published var currentTransferOption: Transfer? = nil {
        didSet {
            if currentTransferOption != oldValue {
                Task { await loadSchedule() }
            }
        }
    }
    
    private let searchService: SearchServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Date Formatters
    
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var routeTitle: String {
        "\(fromStationName) → \(toStationName)"
    }
    
    // MARK: - Init
    
    init(fromStationCode: String,
         toStationCode: String,
         fromStationName: String,
         toStationName: String,
         initialDepartureTimes: Set<Time> = [],
         initialTransferOption: Transfer? = nil,
         searchService: SearchServiceProtocol = SearchService(
            client: Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport()),
            apikey: "ec1e3fff-aa6e-48b3-af0d-9428908e4a06"
         )) {
             self.fromStationCode = fromStationCode
             self.toStationCode = toStationCode
             self.fromStationName = fromStationName
             self.toStationName = toStationName
             self.searchService = searchService
             self.currentDepartureTimes = initialDepartureTimes
             self.currentTransferOption = initialTransferOption
             setupFilterAndDate()
             updateFilterCircleVisibility()
         }
    
    // MARK: - Public Methods
    
    func updateFilters(departureTimes: Set<Time>, transferOption: Transfer?) {
        self.currentDepartureTimes = departureTimes
        self.currentTransferOption = transferOption
        updateFilterCircleVisibility()
    }
    
    private func updateFilterCircleVisibility() {
        showFilterCircle = !currentDepartureTimes.isEmpty || currentTransferOption != nil
    }
    
    func loadSchedule() async {
        isLoading = true
        errorType = nil
        scheduleList = []
        let dateStringForAPI = apiDateFormatter.string(from: selectedDate)
        do {
            let apiResponse = try await searchService.getScheduleBetweenStations(
                from: fromStationCode,
                to: toStationCode,
                date: dateStringForAPI
            )
            print("API Response received: \(apiResponse)")
            if let segments = apiResponse.segments {
                print("Number of segments in API response: \(segments.count)")
                let filteredSegments = segments.filter { segment in
                    if !currentDepartureTimes.isEmpty, let departureDate = segment.departure {
                        let departureHour = Calendar.current.component(.hour, from: departureDate)
                        let isTimeMatch = currentDepartureTimes.contains (where: {timeFilter in
                            timeFilter.hourRange().contains(departureHour)
                        })
                        guard isTimeMatch else { return false }
                    }
                    if let transferOption = currentTransferOption {
                        guard let transfers = segment.tickets_info?.et_marker else {
                            return false
                        }
                        if transferOption == .yes && !transfers { return false }
                        if transferOption == .no && transfers { return false }
                    }
                    return true
                }
                self.scheduleList = filteredSegments.compactMap { (apiSegment) -> Сarrier? in
                    guard let thread = apiSegment.thread else {
                        print("[ScheduleViewModel.loadSchedule]: missing thread: \(apiSegment)")
                        return nil
                    }
                    guard let carrierAPI = thread.carrier else {
                        print("[ScheduleViewModel.loadSchedule]: missing carrierAPI in thread: \(apiSegment)")
                        return nil
                    }
                    guard let carrierCode = carrierAPI.code else {
                        print("[ScheduleViewModel.loadSchedule]: missing carrierCode in carrierAPI: \(apiSegment)")
                        return nil
                    }
                    guard let departureDate = apiSegment.departure else {
                        print("[ScheduleViewModel.loadSchedule]: missing departureDate: \(apiSegment)")
                        return nil
                    }
                    guard let arrivalDate = apiSegment.arrival else {
                        print("[ScheduleViewModel.loadSchedule]: missing arrivalDate: \(apiSegment)")
                        return nil
                    }
                    guard let duration = apiSegment.duration else {
                        print("[ScheduleViewModel.loadSchedule]: missing durationSeconds: \(apiSegment)")
                        return nil
                    }
                    guard let transfer = apiSegment.tickets_info?.et_marker else {
                        print("[ScheduleViewModel.loadSchedule]: missing transfers in segment: \(apiSegment)")
                        return nil
                    }
                    let formattedDepartureTime = timeFormatter.string(from: departureDate)
                    let formattedArrivalTime = timeFormatter.string(from: arrivalDate)
                    let durationHours = Int(duration / 3600)
                    let hours = hoursString(for: durationHours)
                    var formattedDuration: String
                    if durationHours > 0 {
                        formattedDuration = "\(durationHours) \(hours)"
                    } else {
                        formattedDuration = "< 1 час"
                    }
                    let formattedDateForDisplay = displayDateFormatter.string(from: selectedDate)
                    return Сarrier(
                        carrierCode: String(carrierCode),
                        carrierLogoName: carrierAPI.logo ?? "https://yastat.net/s3/rasp/media/data/company/logo/rzd.gif",
                        carrierName: carrierAPI.title ?? "",
                        transfer: transfer ? "" : nil,
                        departureTime: formattedDepartureTime,
                        arrivalTime: formattedArrivalTime,
                        duration: formattedDuration,
                        date: formattedDateForDisplay,
                        fromStation: apiSegment.from?.title,
                        toStation: apiSegment.to?.title
                    )
                }
            } else {
                print("[ScheduleViewModel.loadSchedule]: API returned no schedule segments.")
                errorType = .server
            }
        } catch {
            print("[ScheduleViewModel.loadSchedule] Error: \(error)")
            if let networkError = error as? NetworkError {
                switch networkError {
                case .noInternet:
                    errorType = .noInternet
                case .serverError(_):
                    errorType = .server
                }
            }
            else {
                errorType = nil
            }
            print("[ScheduleViewModel.loadSchedule] Error: \(error.localizedDescription)")
            print("[ScheduleViewModel.loadSchedule] ErrorType set to: \(errorType ?? nil)")
        }
        isLoading = false
    }
    
    func hoursString(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "часов"
        }
        switch lastDigit {
        case 1:
            return "час"
        case 2, 3, 4:
            return "часа"
        default:
            return "часов"
        }
    }
    
    // MARK: - Private Methods
    
    private func setupFilterAndDate() {
        Publishers.CombineLatest3($selectedDate, $currentDepartureTimes, $currentTransferOption)
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] (date, times, transfer) in
                guard let self = self else { return }
                print("ScheduleViewModel: Filters or date changed (Date: \(self.displayDateFormatter.string(from: date)), Times: \(times.count), Transfer: \(transfer?.rawValue ?? "nil")), refetching schedule...")
                Task { await self.loadSchedule() }
            }
            .store(in: &cancellables)
    }
}
