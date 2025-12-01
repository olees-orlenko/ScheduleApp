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
    private let networkClient: NetworkClient

    // MARK: - Init
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
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
            try await networkClient.applyFilters(
                departureTimes: selectedDepartureTime,
                transferOption: selectedTransfer
            )
            print("Фильтры успешно применены.")
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
