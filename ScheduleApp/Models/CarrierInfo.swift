import Foundation

struct CarrierInfo {
    let carrierLogoName: String
    let carrierFullName: String
    let email: String
    let phone: String
}

extension CarrierInfo {
    static let carrier: [CarrierInfo] = [
        CarrierInfo(
            carrierLogoName: "RZD",
            carrierFullName: "ОАО 'РЖД'",
            email: "i.lozkgina@yandex.ru",
            phone: "+7 (904) 329-27-71",
        ),
    ]
}
