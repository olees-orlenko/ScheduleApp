import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        let testStation = Station(name: "Test Station")
        let mockStations = [
            Station(name: "Станция 1"),
            Station(name: "Станция 2"),
            Station(name: "Станция 3")
        ]
        let mockCity = City(name: "Москва", stations: mockStations)
        if isActive {
            MainView(selectedStation: testStation, selectedCity: mockCity, path: .constant(NavigationPath()))
        } else {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                Image("Splash Screen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
