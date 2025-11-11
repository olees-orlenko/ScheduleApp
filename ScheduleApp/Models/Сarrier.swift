import Foundation

struct Сarrier: Identifiable {
    let id = UUID()
    let carrierLogoName: String
    let carrierName: String
    let transfer: String?
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let date: String
}

extension Сarrier {
    static let schedule: [Сarrier] = [
        Сarrier(
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января"
        ),
        Сarrier(
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января"
        ),
        Сarrier(
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января"
        ),
        Сarrier(
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января"
        ),
        Сarrier(
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января"
        ),
        Сarrier(
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января"
        ),
    ]
}
