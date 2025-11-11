import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.viewBackgroundColor
        let tabBarLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        tabBarLine.backgroundColor = colors.tabBarLineColor
        tabBar.addSubview(tabBarLine)
        let testStation = Station(name: "Test Station")
        let mockStations = [
            Station(name: "Станция 1"),
            Station(name: "Станция 2"),
            Station(name: "Станция 3")
        ]
        let mockCity = City(name: "Москва", stations: mockStations)
        let mainSwiftUIView = MainView(selectedStation: testStation, selectedCity: mockCity, path: .constant(NavigationPath()))
        let mainHostingController = UIHostingController(rootView: mainSwiftUIView)
        let mainNavController = UINavigationController(rootViewController: mainHostingController)
        mainNavController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "Schedule"),
            tag: 0)
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "Vector"),
            selectedImage: nil
        )
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        viewControllers = [mainNavController, settingsNavigationController]
        tabBar.tintColor = colors.navigationBarTintColor
        tabBar.unselectedItemTintColor = UIColor(resource: .gray)
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
            }
        }
    }
}
