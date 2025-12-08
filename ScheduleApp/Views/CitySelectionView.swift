import SwiftUI

// MARK: - CitySelectionView

struct CitySelectionView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = StationsListViewModel()
    @State private var path = NavigationPath()
    @State private var searchText: String = ""
    @Binding var selectedStationCode: String
    @Binding var selectedStationName: String
    @Environment(\.dismiss) var dismiss
    
    private var filteredCities: [City] {
        if searchText.isEmpty {
            return viewModel.allCities
        } else {
            return viewModel.allCities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: - Body
    
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
                    if let errorType = viewModel.errorType {
                                ErrorView(type: errorType)
                    } else if filteredCities.isEmpty && !searchText.isEmpty {
                        Text("Город не найден")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    } else {
                        List {
                            ForEach(filteredCities) { city in
                                Button(action: {
                                    path.append(city)
                                }) {
                                    HStack {
                                        Text(city.name)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(.chevron)
                                            .renderingMode(.template)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color(.systemBackground))
                            }
                        }
                        .listStyle(.plain)
                        .background(Color(.systemBackground).ignoresSafeArea())
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: City.self) { city in
                StationSelectionView(
                    city: city,
                    onDismiss: {dismiss()},
                    path: $path,
                    selectedStationCode: $selectedStationCode,
                    selectedStationName: $selectedStationName
                )
            }
            .onAppear {
                print("CitySelectionView appeared. AllCities count: \(viewModel.allCities.count), isLoading: \(viewModel.isLoading)")
                if viewModel.allCities.isEmpty && !viewModel.isLoading {
                    Task {
                        print("Calling loadAllStations() from onAppear...")
                        await viewModel.loadAllStations()
                        print("loadAllStations() finished. AllCities count now: \(viewModel.allCities.count), Error: \(viewModel.errorType?.message ?? "None")")
                    }
                }
            }
        }
    }
}

// MARK: - CitySelectionView_Preview

#Preview {
    @State var selectedStationCode: String = ""
    @State var selectedStationName: String = ""
    CitySelectionView(selectedStationCode: $selectedStationCode, selectedStationName: $selectedStationName)
}
