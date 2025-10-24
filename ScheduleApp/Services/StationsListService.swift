import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias StationsList = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations(limit: Int?) async throws -> StationsList
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations(limit: Int? = nil) async throws -> StationsList {
        let response = try await client.getAllStations(query: .init(
            apikey: apikey
        ))
        let responseBody = try response.ok.body.text_html_charset_utf_hyphen_8
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        let allStations = try JSONDecoder().decode(StationsList.self, from: fullData)
        return allStations
    } 
}

func testFetchStationsList(){
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = StationsListService(
                client: client,
                apikey: "YOUR_API_KEY"
            )
            print("Fetching allStations...")
            let allStations = try await service.getAllStations(
            )
            print("Successfully fetched allStations")
        } catch {
            print("Error fetching allStations: \(error)")
        }
    }
}
