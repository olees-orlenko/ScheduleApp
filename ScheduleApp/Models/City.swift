import Foundation

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stations: [Station]
    let yandexCode: String?
    var selectedStation: Station?
}
