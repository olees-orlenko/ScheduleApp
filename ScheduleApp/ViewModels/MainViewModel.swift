import SwiftUI
import Combine

// MARK: - MainViewModel

@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var departureStationCode: String = ""
    @Published var departureStationName: String = Constants.MainView.from
    @Published var arrivalStationCode: String = ""
    @Published var arrivalStationName: String = Constants.MainView.to
    @Published var citySelectionForDeparture: Bool = false
    @Published var citySelectionForArrival: Bool = false
    @Published var isFindButtonTapped: Bool = false
    @Published var stories: [Story] = [.story1, .story2, .story3, .story4]
    @Published var currentStoryIndex: Int = 0
    @Published var showFullScreenStory: Bool = false
    
    var isFindButtonEnabled: Bool {
        !departureStationCode.isEmpty && !arrivalStationCode.isEmpty
    }
    
    // MARK: - Public Methods
    
    func swapStations() {
        let cityCode = departureStationCode
        let cityName = departureStationName
        departureStationCode = arrivalStationCode
        departureStationName = arrivalStationName
        arrivalStationCode = cityCode
        arrivalStationName = cityName
    }
    
    func handleStoryTap(index: Int) {
        currentStoryIndex = index
        showFullScreenStory = true
    }
    
    func markStoryAsSeen(index: Int) {
        if index >= 0 && index < stories.count {
            stories[index].isSeen = true
        }
    }
}
