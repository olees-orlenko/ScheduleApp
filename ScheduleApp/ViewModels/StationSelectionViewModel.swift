import Foundation
import Combine
import SwiftUI

// MARK: - StationSelectionViewModel

@MainActor
final class StationSelectionViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var searchText: String = ""
    @Published var filteredStations: [Station] = []
    private let city: City
    private var allStations: [Station]
    
    // MARK: - Init
    
    init(city: City) {
        self.city = city
        self.allStations = city.stations
        self.filterStations()
    }
    
    // MARK: - Public Methods

    func filterStations() {
        if searchText.isEmpty {
            filteredStations = allStations
        } else {
            filteredStations = allStations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func selectStation(station: Station) -> (code: String, name: String) {
        return (station.yandexCode, "\(city.name), \(station.name)")
    }
}
