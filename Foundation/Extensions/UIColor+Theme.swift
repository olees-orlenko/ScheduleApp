import UIKit

extension UIColor {
    
    static var viewBackground: UIColor {
        .systemBackground
    }
    
    static var navigationBarTint: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? .white : .black
        }
    }
    
    static var tabBarLine: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .light ? .gray : .black
        }
    }
    
    static var imageTint: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .light ? .black : .white
        }
    }
    
    static var themeTint: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? .white : .black
        }
    }
}
