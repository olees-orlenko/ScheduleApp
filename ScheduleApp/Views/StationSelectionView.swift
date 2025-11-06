import SwiftUI

struct StationSelectionView: View {
    let city: City
    @Binding var path: NavigationPath
    
    @State private var searchText: String = ""
    
    private var filteredStations: [Station] {
        if searchText.isEmpty {
            return city.stations
        } else {
            return city.stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private let backButtonWidth: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image("Chevron left")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundColor(.primary)
                        .padding(.leading, 8)
                }
                .frame(width: backButtonWidth, alignment: .leading)
                Spacer()
                
                Text("Выбор станции")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Spacer()
                    .frame(width: backButtonWidth)
            }
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
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(.lightGray))
                    .padding(.trailing, -7)
                    .onTapGesture {
                        if !searchText.isEmpty {
                            searchText = ""
                        }
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            List {
                ForEach(filteredStations) { station in
                    HStack {
                        Text(station.name)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.primary)
                        Spacer()
                        
                        Image("Chevron")
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        path.append(CityStationPair(city: city, station: station))
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemBackground))
                }
            }
            .listStyle(.plain)
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let mockStations = [
        Station(name: "Станция 1"),
        Station(name: "Станция 2"),
        Station(name: "Станция 3")
    ]
    let mockCity = City(name: "Москва", stations: mockStations)
    StationSelectionView(city: mockCity, path: .constant(NavigationPath()))
}
