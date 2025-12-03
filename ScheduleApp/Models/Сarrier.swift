import Foundation

struct Сarrier: Identifiable {
    let id = UUID()
    let carrierCode: String
    let carrierLogoName: String?
    let carrierName: String
    let transfer: String?
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let date: String
    let fromStation: String?
    let toStation: String?
}

extension Сarrier {
    static let schedule: [Сarrier] = [
        Сarrier(
            carrierCode: "680",
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            fromStation: "",
            toStation: ""
        ),
        Сarrier(
            carrierCode: "680",
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            fromStation: "",
            toStation: ""
        ),
        Сarrier(
            carrierCode: "680",
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            fromStation: "",
            toStation: ""
        ),
        Сarrier(
            carrierCode: "680",
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            fromStation: "",
            toStation: ""
        ),
        Сarrier(
            carrierCode: "680",
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            fromStation: "",
            toStation: ""        ),
        Сarrier(
            carrierCode: "680",
            carrierLogoName: "Brand Icon",
            carrierName: "РЖД",
            transfer: "С пересадкой в Костроме",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            fromStation: "",
            toStation: ""
        ),
    ]
}
