import Foundation

enum NetworkError: Error, LocalizedError {
    case noInternet
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Нет подключения к интернету."
        case .serverError(let statusCode):
            return "Ошибка сервера: \(statusCode)."
        }
    }
}

actor NetworkClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func checkApiAvailability() async throws {
        try await Task.sleep(for: .seconds(1))
        print("API is available.")
    }
}
