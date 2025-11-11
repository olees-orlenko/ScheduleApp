import SwiftUI

struct TabBarView: View {
    
    let testStation: Station
    let mockStations: [Station]
    let mockCity: City
    private let colors = Colors()
    
    init() {
        self.testStation = Station(name: "Test Station")
        self.mockStations = [
            Station(name: "Станция 1"),
            Station(name: "Станция 2"),
            Station(name: "Станция 3")
        ]
        self.mockCity = City(name: "Москва", stations: self.mockStations)
        
        let appearance = UITabBarAppearance()
        appearance.shadowColor = UIColor.separator
        appearance.backgroundColor = .systemBackground
        appearance.configureWithOpaqueBackground()
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color("gray"))
        itemAppearance.selected.iconColor = colors.navigationBarTintColor
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
                SettingsViewRepresentable()
            }
            .tabItem {
                Image("Vector")
            }
            .tag(1)
        }
    }
}
