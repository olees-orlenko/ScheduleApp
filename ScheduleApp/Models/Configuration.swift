import SwiftUI

// MARK: - Configuration Struct

struct StoryConfiguration {
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
