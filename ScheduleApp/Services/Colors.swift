import UIKit

final class Colors {
    
    let viewBackgroundColor = UIColor.systemBackground
    
    let navigationBarTintColor: UIColor = UIColor { (traits: UITraitCollection) -> UIColor in
        switch traits.userInterfaceStyle {
        case .dark:
            return .white
        default:
            return .black
            
        }
    }
    
    let tabBarLineColor: UIColor = UIColor { (traits: UITraitCollection) -> UIColor in
        switch traits.userInterfaceStyle {
        case .light:
            return .gray
        default:
            return .black
        }
    }
    
    let imageTintColor: UIColor = UIColor { (traits: UITraitCollection) -> UIColor in
        switch traits.userInterfaceStyle {
        case .light:
            return .black
        default:
            return .white
        }
    }
    
    func themeTintColor() -> UIColor {
        return UIColor { (traits) -> UIColor in
            switch traits.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
    }
}
