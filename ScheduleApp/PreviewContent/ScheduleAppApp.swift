import SwiftUI

@main
struct ScheduleAppApp: App {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
        }
    }
}
