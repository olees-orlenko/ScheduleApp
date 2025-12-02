import SwiftUI
import Combine
import OpenAPIURLSession
import OpenAPIRuntime

typealias APICarrierResponse = Components.Schemas.CarrierResponse
typealias APICarrier = Components.Schemas.Carrier

// MARK: - CarrierViewModel

@MainActor
final class CarrierViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var carrier: APICarrier?
    @Published var isLoading: Bool = false
    @Published var errorType: ErrorType?
    let carrierCode: String
    private let carrierService: CarrierServiceProtocol
    
    // MARK: - Init
    
    init(carrierCode: String, carrierService: CarrierServiceProtocol = CarrierService(client: Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport()), apikey: "YOUR_API_KEY")) {
        self.carrierCode = carrierCode
        self.carrierService = carrierService
    }
    
    // MARK: - Public Methods
    
    func loadCarrierInfo() async {
        isLoading = true
        errorType = nil
        do {
            let response = try await carrierService.getCarrierInfo(code: carrierCode)
            self.carrier = response.carrier
            print("Successfully loaded carrier info for code: \(carrierCode)")
            if let loadedCarrier = self.carrier {
                print("Successfully loaded carrier info for code: \(carrierCode): \(loadedCarrier.title ?? "No title")")
            } else {
                print("Successfully loaded response, but carrier object is nil for code: \(carrierCode)")
                errorType = .server
            }
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case .noInternet:
                    errorType = .noInternet
                case .serverError(_):
                    errorType = .server
                default:
                    errorType = .server
                }
            }
            else {
                errorType = .server
            }
            print("[CarrierViewModel.loadCarrierInfo] Error: \(error.localizedDescription)")
            print("ErrorType set to: \(errorType ?? .server)")
        }
        isLoading = false
    }
    
    // MARK: - Helpers
    
    var carrierLogoURL: URL? {
        guard let logoString = carrier?.logo, !logoString.isEmpty, let url = URL(string: logoString) else {
            return nil
        }
        return url
    }
    
    var carrierLogoName: String {
        carrierLogoURL?.absoluteString ?? ""
    }
    
    var carrierFullName: String {
        carrier?.title ?? ""
    }
    
    var carrierEmail: String {
        (carrier?.email?.isEmpty == false ? carrier?.email : nil) ?? ""
    }
    
    var carrierPhone: String {
        (carrier?.phone?.isEmpty == false ? carrier?.phone : nil) ?? ""
    }
}
