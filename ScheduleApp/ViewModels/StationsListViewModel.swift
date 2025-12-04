import SwiftUI
import Combine
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - StationsListViewModel

@MainActor
final class StationsListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var scheduleList: [Сarrier] = []
    @Published var allCities: [City] = []
    @Published var isLoading: Bool = false
    @Published var errorType: ErrorType? = nil
    private let stationsListService: StationsListServiceProtocol
    
    // MARK: - Init
    
    init(stationsListService: StationsListServiceProtocol = StationsListService(
        client: Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport()),
        apikey: "ec1e3fff-aa6e-48b3-af0d-9428908e4a06"
    )) {
        self.stationsListService = stationsListService
    }
    
    // MARK: - Public Methods
    
    func loadAllStations() async {
        isLoading = true
        errorType = nil
        scheduleList = []
        do {
            let apiResponse = try await stationsListService.getAllStations(limit: nil)
            self.allCities = getCities(apiResponse: apiResponse)
            if self.allCities.isEmpty {
                print("[StationsListViewModel.loadAllStations] Error: Не удалось загрузить список городов/станций.")
            }
        } catch {
            print("[StationsListViewModel.loadAllStations] Raw Error: \(error)")
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
            print("[StationsListViewModel.loadAllStations] Error: \(errorType?.message ?? "Unknown Error")")
            print("ErrorType set to: \(errorType ?? .server)")
        }
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func getCities(apiResponse: Components.Schemas.AllStationsResponse) -> [City] {
        var cities: [City] = []
        guard let countries = apiResponse.countries else { return [] }
        for country in countries {
            guard let regions = country.regions else { continue }
            for region in regions {
                guard let settlements = region.settlements else { continue }
                for settlement in settlements {
                    guard let settlementTitle = settlement.title, !settlementTitle.isEmpty else {
                        print("[StationsListViewModel.getCities] Settlement title is empty.")
                        continue
                    }
                    print("[StationsListViewModel.getCities] settlement: '\(settlementTitle)' (length: \(settlementTitle.count))")
                    var newStations: [Station] = []
                    if let stations = settlement.stations {
                        for station in stations {
                            if let stationTitle = station.title,
                               let yandexCode = station.codes?.yandex_code {
                                newStations.append(Station(name: stationTitle, yandexCode: yandexCode))
                            } else {
                                print("[StationsListViewModel.getCities] Station title or yandexCode is nil, skipping station '\(settlementTitle)'.")
                            }
                        }
                    }
                    let cityYandexCode = settlement.codes?.yandex_code
                    
                    if !newStations.isEmpty {
                        cities.append(City(name: settlementTitle, stations: newStations, yandexCode: cityYandexCode))
                        print("[StationsListViewModel.getCities] add city: '\(settlementTitle)' with \(newStations.count) stations.")
                    } else {
                        print("[StationsListViewModel.getCities] settlement '\(settlementTitle)'.")
                    }
                }
            }
        }
        print("[StationsListViewModel.getCities] finished mapping. Found \(cities.count) cities.")
        return cities.sorted { $0.name < $1.name }
    }
}
