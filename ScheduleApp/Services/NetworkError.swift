import Foundation
import Logging

enum NetworkError: Error, LocalizedError {
    case noInternet
    case serverError(statusCode: Int)
    case undocumented(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            "Нет подключения к интернету."
        case .serverError(let statusCode):
            "Ошибка сервера: \(statusCode)."
        case .undocumented(let statusCode):
            "Неизвестная ошибка: \(statusCode)"
        }
    }
}

actor NetworkClient {
    private let session: URLSession
    private static let logger = Logger(label: "com.yourapp.NetworkClient")
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func checkApiAvailability() async throws {
        do {
            try await Task.sleep(for: .seconds(1))
            NetworkClient.logger.info("API is available.")
        } catch let cancellationError as CancellationError {
            NetworkClient.logger.warning("API check was cancelled. Error: \(cancellationError)")
            throw cancellationError
        } catch let error {
            NetworkClient.logger.error("API is not available: \(error)")
            throw error
        }
    }
}
