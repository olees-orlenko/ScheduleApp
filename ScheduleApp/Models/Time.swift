import Foundation

enum Time: String, CaseIterable, Identifiable {
    case morning = "Утро 06:00 - 12:00"
    case day = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"
    var id: String { self.rawValue }
    
    var hourRange: ClosedRange<Int> {
        switch self {
        case .morning: 6...11
        case .day: 12...17
        case .evening: 18...23
        case .night: 0...5
        }
    }
}
