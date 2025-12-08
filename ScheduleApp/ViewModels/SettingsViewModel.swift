import SwiftUI
import Combine

// MARK: - SettingsViewModel

@MainActor
final class SettingsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = false {
        didSet {
            print("Dark mode enabled: \(isDarkModeEnabled)")
        }
    }
    @Published var errorType: ErrorType? = nil
    @Published var appVersion: String = Constants.SettingsView.appVersion
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersion = version
        }
    }
    
    // MARK: - Public Methods
    
    func checkAppDependencies() async {
        errorType = nil
        do {
            try await networkClient.checkApiAvailability()
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
            } else {
                errorType = .server
            }
            print("[SettingsViewModel.checkAppDependencies] Error: \(error.localizedDescription)")
        }
    }
}
