import SwiftUI
import Combine

// MARK: - FullScreenStoryView

struct FullScreenStoryView: View {
    
    // MARK: - Properties
    
    let stories: [Story]
    @Binding var currentStoryIndex: Int
    @Binding var showFullScreenStory: Bool
    let onStoryMarkedSeen: (Int) -> Void
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 3, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    private var currentStory: Story { stories[currentStoryIndex] }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $currentStoryIndex) {
            ForEach(stories.indices, id: \.self) { index in
                ZStack {
                    storyImage(for: stories[index])
                    VStack() {
                        closeButton
                        Spacer()
                        storyContent(for: stories[index])
                    }
                }
                tag(index)
                    .onAppear {
                        print("OnAppear story at index: \(index), currentStoryIndex is now: \(currentStoryIndex)")
                        resetTimer()
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color(.black))
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .onAppear {
            print("FullScreenStoryView appeared. Initial index: \(currentStoryIndex)")
            startTimer()
        }
        .onDisappear {
            print("FullScreenStoryView disappeared.")
            stopTimer()
        }
        .onReceive(timer) { _ in
            nextStory()
            resetTimer()
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
            resetTimer()
        }
    }
    
    // MARK: - Views
    
    private func storyImage(for story: Story) -> some View {
        Image(story.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(40)
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
                    .padding()
                    .contentShape(Rectangle())
            }
            .highPriorityGesture(TapGesture().onEnded {
                print("High priority close button tapped!")
                showFullScreenStory = false
            })
        }
        .padding(.horizontal)
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
    
    private func nextStory() {
        onStoryMarkedSeen(currentStoryIndex)
        let nextStoryIndex = currentStoryIndex + 1
        if nextStoryIndex < stories.count {
            currentStoryIndex = nextStoryIndex
        } else {
            onStoryMarkedSeen(currentStoryIndex)
            showFullScreenStory = false
        }
    }
    
    private func previousStory() {
        let previousStoryIndex = currentStoryIndex - 1
        if previousStoryIndex >= 0 {
            currentStoryIndex = previousStoryIndex
        }
    }
    
    private func resetTimer() {
        stopTimer()
        timer = Timer.publish(every: 5, on: .main, in: .common)
        startTimer()
    }
    
    private func startTimer() {
        cancellable = timer.connect()
    }
    
    private func stopTimer() {
        cancellable?.cancel()
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
