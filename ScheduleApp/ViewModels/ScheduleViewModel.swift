import SwiftUI
import Combine
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - ScheduleViewModel

@MainActor
final class ScheduleViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var scheduleList: [Сarrier] = []
    @Published var isLoading: Bool = false
    @Published var errorType: ErrorType?
    @Published var fromStationCode: String
    @Published var toStationCode: String
    @Published var fromStationName: String
    @Published var toStationName: String
    @Published var selectedDate: Date = Date()
    private let searchService: SearchServiceProtocol
    
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
         searchService: SearchServiceProtocol = SearchService(
            client: Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport()),
            apikey: "YOUR_API_KEY"
         )) {
        self.fromStationCode = fromStationCode
        self.toStationCode = toStationCode
        self.fromStationName = fromStationName
        self.toStationName = toStationName
        self.searchService = searchService
        Task {
            await loadSchedule()
        }
    }
    
    // MARK: - Public Methods
    
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
                self.scheduleList = segments.compactMap { (apiSegment) -> Сarrier? in
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
                        transfer: apiSegment.tickets_info?.et_marker == true ? "пересадки" : nil,
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
                errorType = .server
            }
            print("[ScheduleViewModel.loadSchedule] Error: \(error.localizedDescription)")
            print("ErrorType set to: \(errorType ?? .server)")
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
}
