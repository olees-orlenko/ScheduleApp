import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getStationSchedule(station: String, date: String?) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(station: String, date: String?) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: date
        ))
        return try response.ok.body.json
    }
}

func testFetchStationScheduleSearch() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let service = ScheduleService(
                client: client,
                apikey: "YOUR_API_KEY"
            )
            print("Fetching Schedule...")
            let schedule = try await service.getStationSchedule(
                station: "s9600213",
                date: "2025-11-01"
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            var jsonString: String?
            if let jsonData = try? encoder.encode(schedule),
               let dataString = String(data: jsonData, encoding: .utf8) {
                jsonString = dataString
                print("Successfully fetched schedule:\n\(jsonString!)")
            } else {
                print("Successfully fetched schedule (debug description): \(schedule)")
            }
        } catch {
            print("Error fetching schedule: \(error)")
        }
    }
}
