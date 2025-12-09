import SwiftUI
import Logging

@main
struct ScheduleAppApp: App {
    init() {
        LoggingSystem.bootstrap(StreamLogHandler.standardOutput)
    }
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
        }
    }
}
