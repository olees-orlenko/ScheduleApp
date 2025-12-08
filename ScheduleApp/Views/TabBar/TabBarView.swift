import SwiftUI

// MARK: - TabBarView

struct TabBarView: View {

    // MARK: - Init
    
    init() {
        TabBarView.configureAppearance()
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            NavigationStack {
                MainView()
            }
            .tabItem {
                Image("Schedule")
            }
            .tag(0)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image("Vector")
            }
            .tag(1)
        }
    }

    private static func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = UIColor.separator
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color("gray"))
        itemAppearance.selected.iconColor = .navigationBarTint
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - TabBarView_Preview

#Preview {
    TabBarView()
        .preferredColorScheme(.light)
}
