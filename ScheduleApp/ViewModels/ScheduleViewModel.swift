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
        defer {
            isLoading = false
        }
        let dateStringForAPI = apiDateFormatter.string(from: selectedDate)
        do {
            let apiResponse = try await searchService.getScheduleBetweenStations(
                from: fromStationCode,
                to: toStationCode,
                date: dateStringForAPI
            )
            guard let segments = apiResponse.segments, !segments.isEmpty else {
                print("[ScheduleViewModel.loadSchedule] API returned no segments, showing empty view.")
                errorType = nil
                return
            }
            print("Number of segments in API response: \(segments.count)")
            print("[ScheduleViewModel.loadSchedule] Before client-side filtering: \(segments.count) segments.")
            let filteredSegments = segments.filter { segment in
                var segmentPassesTimeFilter = true
                if !currentDepartureTimes.isEmpty, let departureDate = segment.departure {
                    let departureHour = Calendar.current.component(.hour, from: departureDate)
                    let isTimeMatch = currentDepartureTimes.contains (where: {timeFilter in
                        timeFilter.hourRange().contains(departureHour)
                    })
                    guard isTimeMatch else { return false }
                }
                if let transferOption = currentTransferOption {
                    let transfers = false
                    print("  Segment: \(segment.thread?.title ?? "Unknown") Has Transfers: \(transfers). Transfer Filter Option: \(transferOption.rawValue)")
                    
                    if transferOption == .yes && !transfers { return false }
                    if transferOption == .no && transfers { return false }
                }
                if segmentPassesTimeFilter {
                    print("  Segment: \(segment.thread?.title ?? "Unknown") PASSED all filters.")
                } else {
                    print("  Segment: \(segment.thread?.title ?? "Unknown") FAILED at least one filter.")
                }
                return true
            }
            print("[ScheduleViewModel.loadSchedule] After client-side filtering: \(filteredSegments.count) segments.")
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
                let transfersAvailable: Bool = false
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
                    transfer: transfersAvailable ? "С пересадкой" : nil,
                    departureTime: formattedDepartureTime,
                    arrivalTime: formattedArrivalTime,
                    duration: formattedDuration,
                    date: formattedDateForDisplay,
                    fromStation: apiSegment.from?.title,
                    toStation: apiSegment.to?.title
                )
            }
            if self.scheduleList.isEmpty {
                print("[ScheduleViewModel.loadSchedule] No schedule found after all filtering and mapping, showing empty view.")
                errorType = nil
            } else {
                print("[ScheduleViewModel.loadSchedule] Successfully loaded \(self.scheduleList.count) schedule items.")
                errorType = nil
            }
            return
        } catch {
            print("[ScheduleViewModel.loadSchedule] Raw Error Type: \(type(of: error)), Localized Description: \(error.localizedDescription)")
            let errorDescription = error.localizedDescription
            if errorDescription.contains("statusCode: 404") {
                print("[ScheduleViewModel.loadSchedule] Detected 404 status code via description. No schedule found.")
                errorType = nil
            } else if errorDescription.contains("statusCode: 400") {
                print("[ScheduleViewModel.loadSchedule] Detected 400 status code via description. Bad request.")
                errorType = .server
            } else if let networkError = error as? NetworkError {
                print("[ScheduleViewModel.loadSchedule] Successfully cast to NetworkError (fallback). Details: \(networkError)")
                switch networkError {
                case .noInternet:
                    errorType = .noInternet
                case .serverError(let responseError):
                    if responseError == 404 {
                        print("[ScheduleViewModel.loadSchedule] Received 404 status code (NetworkError.serverError, fallback). No schedule found.")
                        errorType = nil
                    } else {
                        errorType = .server
                    }
                case .undocumented(let responseError):
                    if responseError == 404 {
                        print("[ScheduleViewModel.loadSchedule] Received undocumented 404 status code (NetworkError.undocumented, fallback). No schedule found.")
                        errorType = nil
                    } else {
                        errorType = .server
                    }
                }
            } else if let urlError = error as? URLError {
                if urlError.code == .cancelled {
                    print("[ScheduleViewModel.loadSchedule] Request cancelled. Not showing error.")
                    errorType = nil
                } else if urlError.code == .notConnectedToInternet || urlError.code == .dataNotAllowed {
                    print("[ScheduleViewModel.loadSchedule] No internet connection. Showing error.")
                    errorType = .noInternet
                } else {
                    print("[ScheduleViewModel.loadSchedule] Generic URLError: \(urlError.localizedDescription). Showing server error.")
                    errorType = .server
                }
            }
            else {
                print("[ScheduleViewModel.loadSchedule] Truly Generic Error (unknown type): \(error.localizedDescription). Showing server error.")
                errorType = .server
            }
        }
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
