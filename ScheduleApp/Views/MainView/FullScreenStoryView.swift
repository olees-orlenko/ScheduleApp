import SwiftUI
import Combine

// MARK: - FullScreenStoryView

struct FullScreenStoryView: View {
    
    // MARK: - Properties
    
    let story: Story
    let stories: [Story]
    @Binding var currentStoryIndex: Int
    @Binding var showFullScreenStory: Bool
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 5, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    private var currentStory: Story { stories[currentStoryIndex] }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            storyImage
            VStack() {
                closeButton
                Spacer()
                storyContent
            }
        }
        .background(Color(.black))
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onReceive(timer) { _ in
            nextStory()
        }
        .onTapGesture {
            nextStory()
            resetTimer()
        }
    }
    
    // MARK: - Views
    
    private var storyImage: some View {
        Image(currentStory.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(40)
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: {
                showFullScreenStory = false
            }) {
                Image(.close)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
    
    private var storyTitleText: some View {
        Text(currentStory.title ?? "")
            .font(.system(size: 34, weight: .bold))
            .kerning(0.4)
            .foregroundColor(.white)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 16)
    }
    
    private var storyMainText: some View {
        Text(currentStory.text)
            .font(.system(size: 20))
            .kerning(0.4)
            .foregroundColor(.white)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 40)
    }
    
    private var storyContent: some View {
        VStack(alignment: .leading) {
            storyTitleText
            storyMainText
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Helpers
    
    private func nextStory() {
        let nextStoryIndex = currentStoryIndex + 1
        if nextStoryIndex < stories.count {
            currentStoryIndex = nextStoryIndex
        } else {
            showFullScreenStory = false
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
    let testStory = Story(imageName: "0", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false)
    let testStories: [Story] = [
        Story(imageName: "1", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false),
        Story(imageName: "Stories 1", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false)]
    FullScreenStoryView(story: testStory, stories: testStories, currentStoryIndex: $currentStoryIndex, showFullScreenStory: $showFullScreenStory)
}
