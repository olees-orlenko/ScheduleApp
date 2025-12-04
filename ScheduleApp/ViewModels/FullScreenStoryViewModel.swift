import Combine
import SwiftUI

// MARK: - FullScreenStoryViewModel

@MainActor
final class FullScreenStoryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var stories: [Story]
    @Published var currentStoryIndex: Int
    @Binding var showFullScreenStory: Bool
    @Published var progress: CGFloat = 0.0
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let onStoryMarkedSeen: (Int) -> Void
    private let configuration: StoryConfiguration
    private var cancellable: AnyCancellable?
    
    var numberOfSections: Int {
        stories.count
    }
    
    var totalProgressForDisplay: CGFloat {
        let sectionProgress = 1.0 / CGFloat(configuration.storiesCount)
        let completedSectionsProgress = CGFloat(currentStoryIndex) * sectionProgress
        let currentSectionFillingProgress = progress * sectionProgress
        return completedSectionsProgress + currentSectionFillingProgress
    }
    
    // MARK: - Init
    
    init(stories: [Story],
         currentStoryIndex: Binding<Int>,
         showFullScreenStory: Binding<Bool>,
         onStoryMarkedSeen: @escaping (Int) -> Void,
         configuration: StoryConfiguration
    ) {
        self._stories = Published(initialValue: stories)
        self._currentStoryIndex = Published(initialValue: currentStoryIndex.wrappedValue)
        self._showFullScreenStory = showFullScreenStory
        self.onStoryMarkedSeen = onStoryMarkedSeen
        self.configuration = configuration
        self.timer = Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common).autoconnect()
    }
    
    deinit {
        Task { @MainActor [weak self] in
            self?.stopTimer()
        }
        print("FullScreenStoryViewModel deinitialized.")
    }
    
    // MARK: - Timer
    
    func startTimer() {
        stopTimer()
        cancellable = timer
            .sink { [weak self] _ in
                
                self?.timerTick()
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func timerTick() {
        var nextProgress = progress + configuration.progressPerTick
        if nextProgress >= 1.0 {
            progress = 1.0
            if currentStoryIndex < configuration.storiesCount - 1 {
                onStoryMarkedSeen(currentStoryIndex)
                currentStoryIndex += 1
                print("Timer: Переходим к следующей истории. Индекс: \(currentStoryIndex)")
            } else {
                print("Timer: Последняя история.")
                onStoryMarkedSeen(currentStoryIndex)
                stopTimer()
                showFullScreenStory = false
            }
        } else {
            progress = nextProgress
        }
    }
    
    // MARK: - Story Navigation
    
    func nextStory() {
        onStoryMarkedSeen(currentStoryIndex)
        let nextStoryIndex = currentStoryIndex + 1
        if nextStoryIndex < stories.count {
            currentStoryIndex = nextStoryIndex
            print("Tap: Переходим к следующей истории. Индекс: \(currentStoryIndex)")
            progress = 0.0
            startTimer()
        } else {
            print("Tap: Последняя история.")
            onStoryMarkedSeen(currentStoryIndex)
            stopTimer()
            showFullScreenStory = false
        }
    }
    
    func previousStory() {
        let previousStoryIndex = currentStoryIndex - 1
        if previousStoryIndex >= 0 {
            currentStoryIndex = previousStoryIndex
            print("Tap: Переходим к предыдущей истории. Индекс:\(currentStoryIndex)")
            progress = 0.0
            startTimer()
        } else {
            print("Tap: Первая история.")
        }
    }
    
    func closeView() {
        print("[FullScreenStoryViewModel] Close button tapped.")
        stopTimer()
        showFullScreenStory = false
    }
}
