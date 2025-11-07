import SwiftUI

struct MainView: View {
    let selectedStation: Station
    let selectedCity: City
    let backButtonWidth: CGFloat
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    @State private var citySelectionForDeparture = false
    @State private var citySelectionForArrival = false
    @State private var departureCity: City? = nil
    @State private var arrivalCity: City? = nil
    
    let stories: [Story] = [
        Story(imageName: "Stories", title: "Text Text Text Text Text T...", isSeen: false),
        Story(imageName: "Stories 1", title: "Text Text Text Text Text T...", isSeen: false),
        Story(imageName: "Stories 2", title: "Text Text Text Text Text T...", isSeen: true),
        Story(imageName: "Stories 3", title: "Text Text Text Text Text T...", isSeen: true)
    ]
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Stories
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
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                        
                        // MARK: - Откуда-Куда
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("blue"))
                                    .frame(width: 343, height: 128)
                                HStack(spacing: -32) {
                                    VStack() {
                                        Button(action: { citySelectionForDeparture = true }) {
                                            VStack(alignment: .leading) {
                                                Text(departureCity?.name ?? "Откуда")
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(departureCity == nil ? Color("gray") : .primary)
                                                    .kerning(-0.41)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        Button(action: { citySelectionForArrival = true }) {
                                            VStack(alignment: .leading) {
                                                Text(arrivalCity?.name ?? "Куда")
                                                    .font(.system(size: 17, weight: .regular))
                                                    .foregroundColor(arrivalCity == nil ? Color("gray") : .primary)
                                                    .kerning(-0.41)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .frame(width: 259, height: 84)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                    )
                                    
                                    Button(action: {
                                        let tmp = departureCity
                                        departureCity = arrivalCity
                                        arrivalCity = tmp
                                    }) {
                                        Image("Сhange")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 36, height: 36)
                                            .foregroundColor(Color("blue"))
                                    }
                                    .padding(.trailing, -32)
                                    .padding(.leading, 16)
                                    .frame(width: 84, height: 128)
                                }
                            }
                            .frame(width: 343, height: 128)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                }
                .navigationBarHidden(true)
                .background(Color(.systemBackground).ignoresSafeArea())
                .sheet(isPresented: $citySelectionForDeparture) {
                    CitySelectionView(selectedCity: $departureCity)
                }
                .sheet(isPresented: $citySelectionForArrival) {
                    CitySelectionView(selectedCity: $arrivalCity)
                }
                .navigationDestination(for: CityStationPair.self) { pair in
                    MainView(selectedStation: pair.station, selectedCity: pair.city, backButtonWidth: backButtonWidth, path: .constant(NavigationPath()))
                }
            }
        }
    }
}

//#Preview {
//    let backButtonWidth: CGFloat = 40
//    let testStation = Station(name: "Test Station")
//    let mockStations = [
//        Station(name: "Станция 1"),
//        Station(name: "Станция 2"),
//        Station(name: "Станция 3")
//    ]
//    let mockCity = City(name: "Москва", stations: mockStations)
//    MainView(selectedStation: testStation, selectedCity: mockCity, backButtonWidth: backButtonWidth, path: .constant(NavigationPath()))
//}
