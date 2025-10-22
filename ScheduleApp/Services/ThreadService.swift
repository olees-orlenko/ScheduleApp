import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias Thread = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol {
    func getRouteStations(uid: String, date: String?) async throws -> Thread
}

final class ThreadService: ThreadServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String, date: String?) async throws -> Thread {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            date: date
        ))
        return try response.ok.body.json
    }
}

func testFetchThread() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ThreadService(
                client: client,
                apikey: "YOUR_API_KEY"
            )
            print("Fetching thread...")
            let schedule = try await service.getRouteStations(
                uid: "SU-1524_251101_c26_12",
                date: nil
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            var jsonString: String?
            if let jsonData = try? encoder.encode(schedule),
               let dataString = String(data: jsonData, encoding: .utf8) {
                jsonString = dataString
                print("Successfully fetched thread:\n\(jsonString!)")
            } else {
                print("Successfully fetched thread (debug description): \(schedule)")
            }
             if let arrivalString = schedule.stops?.first?.arrival {
                 print("Дата прибытия: \(arrivalString)")
              }
        } catch {
            print("Error fetching thread: \(error)")
        }
    }
}
