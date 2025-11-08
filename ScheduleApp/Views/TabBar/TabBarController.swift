import UIKit

final class TabBarController: UITabBarController {
    
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.viewBackgroundColor
        let tabBarLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        tabBarLine.backgroundColor = colors.tabBarLineColor
        tabBar.addSubview(tabBarLine)
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "Schedule"),
            selectedImage: nil
        )
        let scheduleNavigationController = UINavigationController(rootViewController: scheduleViewController)
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "Vector"),
            selectedImage: nil
        )
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        viewControllers = [scheduleNavigationController, settingsNavigationController]
        tabBar.tintColor = colors.navigationBarTintColor
        tabBar.unselectedItemTintColor = UIColor(resource: .gray)
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
            }
        }
    }
}
