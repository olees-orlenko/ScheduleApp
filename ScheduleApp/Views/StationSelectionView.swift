import SwiftUI

struct StationSelectionView: View {
    let city: City
    let onDismiss: () -> Void
    @Binding var path: NavigationPath
    @Binding var selectedCityBinding: City?
    
    @State private var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    
    private var filteredStations: [Station] {
        if searchText.isEmpty {
            return city.stations
        } else {
            return city.stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLeftButtonView(title: "Выбор станции", showBackButton: true, backAction: {
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
                        var resultCity = city
                        resultCity.selectedStation = station
                        selectedCityBinding = resultCity
                        onDismiss()
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

//#Preview {
//    let mockStations = [
//        Station(name: "Станция 1"),
//        Station(name: "Станция 2"),
//        Station(name: "Станция 3")
//    ]
//    let mockCity = City(name: "Москва", stations: mockStations)
//    StationSelectionView(city: mockCity, path: .constant(NavigationPath()))
//}
