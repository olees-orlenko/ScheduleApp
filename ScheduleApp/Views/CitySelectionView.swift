import SwiftUI

struct CitySelectionView: View {
    
    let cities: [City] = [
        City(name: "Москва", stations: [
            Station(name: "Павелецкий вокзал"),
            Station(name: "Курский вокзал")
        ]),
        City(name: "Санкт-Петербург", stations: [
            Station(name: "Московский вокзал"),
            Station(name: "Ладожский вокзал")
        ]),
        City(name: "Новосибирск", stations: [
            Station(name: "Новосибирск-Главный")
        ])
    ]
    
    @State private var path = NavigationPath()
    @State private var searchText: String = ""
    @Binding var selectedCity: City?
    @Environment(\.dismiss) var dismiss
    
    private var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                NavigationLeftButtonView(title: "Выбор города", showBackButton: true, backAction: {
                    dismiss()
                })
                .padding(.vertical, 11)
                .background(Color(.systemBackground))
                .shadow(radius: 0)
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, -8)
                    TextField("Введите запрос", text: $searchText)
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    if !searchText.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.gray))
                            .padding(.trailing, -7)
                            .onTapGesture {
                                searchText = ""
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color("SearchFieldBackground"))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                ZStack {
                    List {
                        ForEach(filteredCities) { city in
                            HStack {
                                Text(city.name)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.primary)
                                Spacer()
                                Image("Chevron")
                                    .renderingMode(.template)
                                    .foregroundColor(.primary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                path.append(city)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color(.systemBackground))
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(.systemBackground).ignoresSafeArea())
                    if filteredCities.isEmpty && !searchText.isEmpty {
                        Text("Город не найден")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: City.self) { city in
                StationSelectionView(city: city, path: $path)
            }
            .navigationDestination(for: CityStationPair.self) { pair in
                MainView(selectedStation: pair.station, selectedCity: pair.city, path: $path)
            }
        }
    }
}

//#Preview {
//    CitySelectionView(selectedCity: .constant(City(name: "Москва", stations: [])))
//}
