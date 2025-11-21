import SwiftUI

// MARK: - StoryView

struct StoryView: View {
    
    // MARK: - Properties
    
    let story: Story
    @Binding var showFullScreenStory: Bool
    let currentIndex: Int
    let onStoryTap: (Int) -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            onStoryTap(currentIndex)
        }) {
            ZStack(alignment: .bottomLeading) {
                storyImage
                storyText
            }
            .frame(width: 92, height: 140)
        }
    }
    
    // MARK: - Views
    
    private var storyImage: some View {
        Image(story.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 92, height: 140)
            .cornerRadius(16)
            .opacity(story.isSeen ? 0.5 : 1.0)
            .overlay(
                !story.isSeen ?
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("blue"), lineWidth: 4)
                : nil
            )
    }
    
    private var storyText: some View {
        Text(story.text)
            .font(.system(size: 12, weight: .regular))
            .kerning(0.4)
            .foregroundColor(.white)
            .lineLimit(3)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
    }
}

// MARK: - StoryView_Preview

#Preview {
    @State var showFullScreenStory = false
    let testStory = Story(imageName: "Stories", title: nil, text: "Text Text Text Text Text Text Text Text Text", isSeen: false)
    StoryView(story: testStory, showFullScreenStory: $showFullScreenStory, currentIndex: 0,
              onStoryTap: { tappedIndex in
        print("Story tapped in preview: \(tappedIndex)")
    })
}
