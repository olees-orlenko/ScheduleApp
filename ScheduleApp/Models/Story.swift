import Foundation

struct Story: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String?
    let text: String
    let isSeen: Bool
    
    static let story1 = Story(
        imageName: "0",
        title: "Text Text Text Text Text Text Text Text Text",
        text: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
        isSeen: false
    )
    
    static let story2 = Story(
        imageName: "1",
        title: "Text Text Text Text Text Text Text Text Text",
        text: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
        isSeen: false
    )
    
    static let story3 = Story(
        imageName: "2",
        title: "Text Text Text Text Text Text Text Text Text",
        text: "Text Text Text Text Text Text Text Text Text",
        isSeen: true
    )
    
    static let story4 = Story(
        imageName: "3",
        title: "Text Text Text Text Text Text Text Text Text",
        text: "Text Text Text Text Text Text Text Text Text",
        isSeen: true
    )
}
