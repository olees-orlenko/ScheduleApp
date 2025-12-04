import SwiftUI

// MARK: - StationSelectionView

struct StationSelectionView: View {
    
    // MARK: - Properties
    
    let onDismiss: () -> Void
    @Binding var path: NavigationPath
    @Binding var selectedStationCode: String
    @Binding var selectedStationName: String
    @State private var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: StationSelectionViewModel

    // MARK: - Init

    init(city: City,
         onDismiss: @escaping () -> Void,
         path: Binding<NavigationPath>,
         selectedStationCode: Binding<String>,
         selectedStationName: Binding<String>) {
        self.onDismiss = onDismiss
        _path = path
        _selectedStationCode = selectedStationCode
        _selectedStationName = selectedStationName
        _viewModel = StateObject(wrappedValue: StationSelectionViewModel(city: city))
    }
    
    // MARK: - Body
    
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
                if !viewModel.searchText.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.gray))
                        .padding(.trailing, -7)
                        .onTapGesture {
                            viewModel.searchText = ""
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
                ForEach(viewModel.filteredStations) { station in
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
                        let selectedStation = viewModel.selectStation(station: station)
                        selectedStationCode = selectedStation.code
                        selectedStationName = selectedStation.name
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
