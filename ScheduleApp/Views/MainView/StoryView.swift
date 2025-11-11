import SwiftUI

struct StoryView: View {
    let story: Story
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
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
            
            Text(story.title)
                .font(.system(size: 12, weight: .regular))
                .kerning(0.4)
                .foregroundColor(.white)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
        }
        .frame(width: 92, height: 140)
    }
}

#Preview {
    let testStory = Story(imageName: "Stories", title: "Text Text Text Text Text Text Text Text Text", isSeen: false)
    StoryView(story: testStory)
}
