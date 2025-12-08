import Foundation
import Combine
import SwiftUI

// MARK: - FilterViewModel

@MainActor
final class FilterViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedDepartureTime: Set<Time> = [] {
        didSet {
            updateApplyButtonVisibility()
        }
    }
    @Published var selectedTransfer: Transfer? = nil {
        didSet {
            updateApplyButtonVisibility()
        }
    }
    @Published var showApplyButton: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    let fromStationCode: String
    let toStationCode: String
    let fromStationName: String
    let toStationName: String
    let onApplyFiltersAndNavigate: (
        _ fromCode: String,
        _ toCode: String,
        _ fromName: String,
        _ toName: String,
        _ departureTimes: [Time],
        _ transferOption: Transfer?
    ) -> Void
    
    // MARK: - Init
    
    init(fromStationCode: String,
         toStationCode: String,
         fromStationName: String,
         toStationName: String,
         onApplyFiltersAndNavigate: @escaping (
            _ fromCode: String,
            _ toCode: String,
            _ fromName: String,
            _ toName: String,
            _ departureTimes: [Time],
            _ transferOption: Transfer?
         ) -> Void,
         initialDepartureTimes: Set<Time>,
         initialTransferOption: Transfer?,
    ) {
        
        self.fromStationCode = fromStationCode
        self.toStationCode = toStationCode
        self.fromStationName = fromStationName
        self.toStationName = toStationName
        self.onApplyFiltersAndNavigate = onApplyFiltersAndNavigate
        self.selectedDepartureTime = initialDepartureTimes
        self.selectedTransfer = initialTransferOption
        updateApplyButtonVisibility()
    }
    
    // MARK: - Public Methods
    
    func toggleDepartureTime(_ time: Time) {
        if selectedDepartureTime.contains(time) {
            selectedDepartureTime.remove(time)
        } else {
            selectedDepartureTime.insert(time)
        }
    }
    
    func selectTransferOption(_ option: Transfer) {
        if selectedTransfer == option {
            selectedTransfer = nil
        } else {
            selectedTransfer = option
        }
    }
    
    func applyFilters() async {
        isLoading = true
        errorMessage = nil
        print("Применены фильтры (FilterViewModel):")
        print("  Время отправления: \(selectedDepartureTime.map { $0.rawValue }.joined(separator: ", "))")
        print("  Варианты с пересадками: \(selectedTransfer?.rawValue ?? "Не выбрано")")
        do {
            onApplyFiltersAndNavigate(
                fromStationCode,
                toStationCode,
                fromStationName,
                toStationName,
                Array(selectedDepartureTime),
                selectedTransfer
            )
            print("FilterViewModel: Фильтры применены через onApplyFiltersAndNavigate.")
        } catch {
            errorMessage = "Ошибка при применении фильтров: \(error.localizedDescription)"
            print("Error applying filters: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func updateApplyButtonVisibility() {
        showApplyButton = !selectedDepartureTime.isEmpty || selectedTransfer != nil
    }
}
