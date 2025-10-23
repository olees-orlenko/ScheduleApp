import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias Carrier = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String) async throws -> Carrier
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String) async throws -> Carrier {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code
        ))
        return try response.ok.body.json
    }
}

func testFetchCarrierInfo() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CarrierService(
                client: client,
                apikey: "YOUR_API_KEY"
            )
            print("Fetching info...")
            let info = try await service.getCarrierInfo(
                code: "680"
            )
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            var jsonString: String?
            if let jsonData = try? encoder.encode(info),
               let dataString = String(data: jsonData, encoding: .utf8) {
                jsonString = dataString
                print("Successfully fetched info:\n\(jsonString!)")
            } else {
                print("Successfully fetched info (debug description): \(info)")
            }
        } catch {
            print("Error fetching info: \(error)")
        }
    }
}
