import SwiftUI

// MARK: - TabBarView

struct TabBarView: View {
    
    // MARK: - Properties
    
    private let testStation: Station
    private let mockStations: [Station]
    private let mockCity: City
    
    // MARK: - Init
    
    init() {
        (testStation, mockStations, mockCity) = TabBarView.makeMockData()
        TabBarView.configureAppearance()
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            NavigationStack {
                MainView(selectedStation: nil, selectedCity: nil)
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
    
    // MARK: - Static Helpers
    
    private static func makeMockData() -> (Station, [Station], City) {
        let testStation = Station(name: "Test Station")
        let mockStations = [
            Station(name: "Станция 1"),
            Station(name: "Станция 2"),
            Station(name: "Станция 3")
        ]
        let mockCity = City(name: "Москва", stations: mockStations)
        return (testStation, mockStations, mockCity)
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
