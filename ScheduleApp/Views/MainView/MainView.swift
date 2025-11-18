import SwiftUI

// MARK: - MainView

struct MainView: View {
    
    // MARK: - Properties
    
    let selectedStation: Station?
    let selectedCity: City?
    
    @Environment(\.dismiss) private var dismiss
    @State private var citySelectionForDeparture = false
    @State private var citySelectionForArrival = false
    @State private var departureCity: City?
    @State private var arrivalCity: City?
    @State private var isFindButtonTapped = false
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled: Bool = false
    
    private var isFindButtonEnabled: Bool {
        departureCity != nil && arrivalCity != nil
    }
    
    private let stories: [Story] = [
        Story(imageName: "Stories", title: "Text Text Text...", isSeen: false),
        Story(imageName: "Stories 1", title: "Text Text Text...", isSeen: false),
        Story(imageName: "Stories 2", title: "Text Text Text...", isSeen: true),
        Story(imageName: "Stories 3", title: "Text Text Text...", isSeen: true)
    ]
    
    // MARK: - Init
    
    init(selectedStation: Station?, selectedCity: City?) {
        self.selectedStation = selectedStation
        self.selectedCity = selectedCity
        _departureCity = State(initialValue: selectedCity)
        _arrivalCity = State(initialValue: nil)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        storiesSection
                        routeSelectionSection
                            .padding(.top, 20)
                        findButtonSection
                    }
                }
                .background(Color(.systemBackground).ignoresSafeArea())
                .navigationBarHidden(true)
            }
            .fullScreenCover(isPresented: $citySelectionForDeparture) {
                CitySelectionView(selectedCity: $departureCity)
                    .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
            }
            .fullScreenCover(isPresented: $citySelectionForArrival) {
                CitySelectionView(selectedCity: $arrivalCity)
                    .environment(\.colorScheme, isDarkModeEnabled ? .dark : .light)
            }
            .navigationDestination(for: CityStationPair.self) { pair in
                MainView(selectedStation: pair.station, selectedCity: pair.city)
            }
        }
    }
    
    // MARK: - Views
    
    private var storiesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories) { story in
                    StoryView(story: story)
                        .padding(.vertical, 2)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 140)
        .padding(.vertical, 24)
    }
    
    private var routeSelectionSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("blue"))
                .frame(width: 343, height: 128)
            
            HStack(spacing: -32) {
                VStack {
                    cityButton(title: displayText(for: departureCity, defaultText: "Откуда")) {
                        citySelectionForDeparture = true
                    }
                    cityButton(title: displayText(for: arrivalCity, defaultText: "Куда")) {
                        citySelectionForArrival = true
                    }
                }
                .frame(width: 259, height: 96)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                )
                swapButton
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
    
    private var swapButton: some View {
        Button {
            (departureCity, arrivalCity) = (arrivalCity, departureCity)
        } label: {
            Image("Сhange")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
        .padding(.trailing, -32)
        .padding(.leading, 16)
        .frame(width: 84, height: 128)
    }

    private var findButtonSection: some View {
        Group {
            if isFindButtonEnabled {
                NavigationLink(
                    destination: ScheduleView()
                        .toolbar(.hidden, for: .tabBar),
                    isActive: $isFindButtonTapped
                ) {
                    EmptyView()
                }
                .hidden()
                Button(action: {
                    isFindButtonTapped = true
                }) {
                    Text("Найти")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 60)
                        .background(Color("blue"))
                        .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 16)
            }
        }
    }
    
    private func cityButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(title == "Откуда" || title == "Куда" ? Color("gray") : .black)
                .kerning(-0.41)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helpers
    
    private func displayText(for city: City?, defaultText: String) -> String {
        guard let city else { return defaultText }
        if let stationName = city.selectedStation?.name {
            return "\(city.name) (\(stationName))"
        }
        return city.name
    }
}

// MARK: - MainView_Preview

#Preview {
    let testStation = Station(name: "Test Station")
    let mockStations = [
        Station(name: "Станция 1"),
        Station(name: "Станция 2"),
        Station(name: "Станция 3")
    ]
    let mockCity = City(name: "Москва", stations: mockStations)
    
    MainView(selectedStation: testStation, selectedCity: mockCity)
        .preferredColorScheme(.light)
        .padding()
}
