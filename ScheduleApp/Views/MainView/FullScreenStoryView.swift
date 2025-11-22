import SwiftUI
import Combine

// MARK: - FullScreenStoryView

struct FullScreenStoryView: View {
    
    // MARK: - Configuration Struct
    
    struct Configuration {
        let timerTickInternal: TimeInterval
        let storyDuration: TimeInterval
        let storiesCount: Int
        let progressPerTick: CGFloat
        
        init(
            storiesCount: Int = 4,
            storyDuration: TimeInterval = 2.5,
            timerTickInternal: TimeInterval = 0.05
        ) {
            self.storiesCount = storiesCount
            self.storyDuration = storyDuration
            self.timerTickInternal = timerTickInternal
            let ticksPerStorySection = storyDuration / timerTickInternal
            self.progressPerTick = 1.0 / CGFloat(ticksPerStorySection)
        }
    }
    
    // MARK: - Properties
    
    let stories: [Story]
    let onStoryMarkedSeen: (Int) -> Void
    @Binding var currentStoryIndex: Int
    @Binding var showFullScreenStory: Bool
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var cancellable: AnyCancellable?
    @State private var progress: CGFloat = 0.0
    private let configuration: Configuration
    private var currentStory: Story { stories[currentStoryIndex] }
    
    private var totalProgressForDisplay: CGFloat {
        let sectionProgress = 1.0 / CGFloat(configuration.storiesCount)
        let completedSectionsProgress = CGFloat(currentStoryIndex) * sectionProgress
        let currentSectionFillingProgress = progress * sectionProgress
        return completedSectionsProgress + currentSectionFillingProgress
    }
    
    // MARK: - Initializer
    
    public init(
        stories: [Story],
        currentStoryIndex: Binding<Int>,
        showFullScreenStory: Binding<Bool>,
        onStoryMarkedSeen: @escaping (Int) -> Void,
        configuration: Configuration = Configuration()
    ) {
        self.stories = stories
        self._currentStoryIndex = currentStoryIndex
        self._showFullScreenStory = showFullScreenStory
        self.onStoryMarkedSeen = onStoryMarkedSeen
        self.configuration = configuration
        self._timer = State(initialValue: Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common).autoconnect())
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            TabView(selection: $currentStoryIndex) {
                ForEach(stories.indices, id: \.self) { index in
                    ZStack {
                        storyImage(for: stories[index])
                        VStack(alignment: .trailing, spacing: 0) {
                            HStack {
                                ProgressBar(numberOfSections: 3, progress: totalProgressForDisplay)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 12)
                                    .padding(.top, 28)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        VStack(alignment: .trailing, spacing: 12) {
                            closeButton
                                .padding(.top, 57)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        VStack {
                            Spacer()
                            storyContent(for: stories[index])
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                    .tag(index)
                    .onAppear {
                        print("OnAppear story at index: \(index), currentStoryIndex is now: \(currentStoryIndex)")
                        progress = 0.0
                        startTimer()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color(.black).edgesIgnoringSafeArea(.all))
            .toolbar(.hidden, for: .tabBar)
            .navigationBarHidden(true)
            .onAppear {
                print("FullScreenStoryView appeared. Initial index: \(currentStoryIndex)")
                progress = 0.0
                startTimer()
            }
            .onDisappear {
                print("FullScreenStoryView disappeared.")
                stopTimer()
            }
            .onReceive(timer) { _ in
                timerTick()
            }
            .onTapGesture { value in
                let screenWidth = UIScreen.main.bounds.width
                if value.x > screenWidth / 2 {
                    print("Tap next story")
                    nextStory()
                } else {
                    print("Tap previous story")
                    previousStory()
                }
            }
        }
    }
    
    // MARK: - Views
    
    private func storyImage(for story: Story) -> some View {
        Image(story.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(40)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                print("Close button tapped!")
                showFullScreenStory = false
            }) {
                Image(.close)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .contentShape(Rectangle())
            }
            .highPriorityGesture(TapGesture().onEnded {
                print("High priority close button tapped!")
                showFullScreenStory = false
            })
        }
        .padding(.trailing, 12)
    }
    
    private func storyTitleText(for story: Story) -> some View {
        Text(story.title ?? "")
            .font(.system(size: 34, weight: .bold))
            .kerning(0.4)
            .foregroundColor(.white)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 16)
    }
    
    private func storyMainText(for story: Story) -> some View {
        Text(story.text)
            .font(.system(size: 20))
            .kerning(0.4)
            .foregroundColor(.white)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 40)
    }
    
    private func storyContent(for story: Story) -> some View {
        VStack(alignment: .leading) {
            storyTitleText(for: story)
            storyMainText(for: story)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Helpers
    
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
    
    private func nextStory() {
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
    
    private func previousStory() {
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
    
    private func startTimer() {
        cancellable?.cancel()
        cancellable = timer.sink { _ in }
    }
    
    private func stopTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
}

// MARK: - FullScreenStoryView_Preview

#Preview {
    @State var showFullScreenStory = true
    @State var currentStoryIndex = 0
    var testStories: [Story] = [
        Story(imageName: "1", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false),
        Story(imageName: "Stories 1", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false)]
    FullScreenStoryView(stories: testStories, currentStoryIndex: $currentStoryIndex, showFullScreenStory: $showFullScreenStory, onStoryMarkedSeen: { index in
        if index >= 0 && index < testStories.count {
            testStories[index].isSeen = true
        }
    }
    )
}
