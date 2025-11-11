import Foundation

enum Transfer: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"

    var id: String { self.rawValue }
}
