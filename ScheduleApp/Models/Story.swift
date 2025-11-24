import Foundation

struct Story: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String?
    let text: String
    var isSeen: Bool
    
    // MARK: - Lorem Ipsum Helper
    
    private static let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    static let story1 = Story(
        imageName: "0",
        title: Story.generateLoremIpsum(words: 10),
        text: Story.generateLoremIpsum(words: 50),
        isSeen: false
    )
    
    static let story2 = Story(
        imageName: "1",
        title: Story.generateLoremIpsum(words: 5),
        text: Story.generateLoremIpsum(words: 10),
        isSeen: false
    )
    
    static let story3 = Story(
        imageName: "2",
        title: Story.generateLoremIpsum(words: 8),
        text: Story.generateLoremIpsum(words: 20),
        isSeen: false
    )
    
    static let story4 = Story(
        imageName: "3",
        title: Story.generateLoremIpsum(words: 12),
        text: Story.generateLoremIpsum(words: 30),
        isSeen: false
    )
    
    static func generateLoremIpsum(words: Int) -> String {
        let allWords = loremIpsum.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        let selectedWords = Array(allWords.prefix(words))
        return selectedWords.joined(separator: " ")
    }
}
