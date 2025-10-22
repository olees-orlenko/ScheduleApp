import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(from: String, to: String, date: String?) async throws -> Segments
}

final class SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String, date: String?) async throws -> Segments {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date
        ))
        return try response.ok.body.json
    }
}

func testFetchSearch() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let service = SearchService(
                client: client,
                apikey: "ec1e3fff-aa6e-48b3-af0d-9428908e4a06"
            )
            print("Fetching Schedule Between Stations...")
            let scheduleResult = try await service.getScheduleBetweenStations(
                from: "c146",
                to: "c213",
                date: "2025-11-01"
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            var jsonString: String?
            if let jsonData = try? encoder.encode(scheduleResult),
               let dataString = String(data: jsonData, encoding: .utf8) {
                jsonString = dataString
                print("Successfully fetched schedule:\n\(jsonString!)")
            } else {
                print("Successfully fetched schedule (debug description): \(scheduleResult)")
            }
        } catch {
            print("Error fetching schedule: \(error)")
        }
    }
}
