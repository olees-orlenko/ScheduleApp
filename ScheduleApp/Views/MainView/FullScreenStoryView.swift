import SwiftUI
import Combine

// MARK: - FullScreenStoryView

struct FullScreenStoryView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: FullScreenStoryViewModel
    private let configuration: StoryConfiguration
    
    // MARK: - Initializer
    
    init(stories: [Story],
         currentStoryIndex: Binding<Int>,
         showFullScreenStory: Binding<Bool>,
         onStoryMarkedSeen: @escaping (Int) -> Void,
         configuration: StoryConfiguration) {
        self.configuration = configuration
        _viewModel = StateObject(wrappedValue: FullScreenStoryViewModel(
            stories: stories,
            currentStoryIndex: currentStoryIndex,
            showFullScreenStory: showFullScreenStory,
            onStoryMarkedSeen: onStoryMarkedSeen,
            configuration: configuration
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.currentStoryIndex) {
                ForEach(viewModel.stories.indices, id: \.self) { index in
                    ZStack {
                        storyImage(for: viewModel.stories[index])
                        VStack(alignment: .trailing, spacing: 0) {
                            HStack {
                                ProgressBar(numberOfSections: 3, progress: viewModel.totalProgressForDisplay)
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
                            storyContent(for: viewModel.stories[index])
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                    .tag(index)
                    .onAppear {
                        print("OnAppear story at index: \(index), currentStoryIndex is now: \(viewModel.currentStoryIndex)")
                        viewModel.progress = 0.0
                        viewModel.startTimer()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color(.black).edgesIgnoringSafeArea(.all))
            .toolbar(.hidden, for: .tabBar)
            .navigationBarHidden(true)
            .onAppear {
                print("FullScreenStoryView appeared. Initial index: \(viewModel.currentStoryIndex)")
                viewModel.progress = 0.0
                viewModel.startTimer()
            }
            .onDisappear {
                print("FullScreenStoryView disappeared.")
                viewModel.stopTimer()
            }
            .onTapGesture { value in
                let screenWidth = UIScreen.main.bounds.width
                if value.x > screenWidth / 2 {
                    print("Tap next story")
                    viewModel.nextStory()
                } else {
                    print("Tap previous story")
                    viewModel.previousStory()
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
                viewModel.closeView()
            }) {
                Image(.close)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .contentShape(Rectangle())
            }
            .highPriorityGesture(TapGesture().onEnded {
                print("High priority close button tapped!")
                viewModel.closeView()
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
}

// MARK: - FullScreenStoryView_Preview

#Preview {
    @State var showFullScreenStory = true
    @State var currentStoryIndex = 0
    let configuration: StoryConfiguration
    var testStories: [Story] = [
        Story(imageName: "1", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false),
        Story(imageName: "Stories 1", title: "Text Text Text Text Text Text Text Text Text", text: "Text Text Text Text Text Text Text Text Text", isSeen: false)]
    FullScreenStoryView(stories: testStories, currentStoryIndex: $currentStoryIndex, showFullScreenStory: $showFullScreenStory, onStoryMarkedSeen: { index in
        if index >= 0 && index < testStories.count {
            testStories[index].isSeen = true
        }
    }, configuration: configuration
    )
}
