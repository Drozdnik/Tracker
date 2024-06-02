import Foundation
import UIKit

final class TabBarViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController(){
        let tracker = TrackerViewController()
        let statistic = StatisticsViewController()
        
        
        let trackerViewController = UINavigationController(rootViewController: tracker)
        trackerViewController.navigationBar.prefersLargeTitles = true
        let statisticViewController = UINavigationController(rootViewController: statistic)
        let trackerTitle = NSLocalizedString("Trackers", comment: "TrackerTitle for tabBar")
        let statisticTitle = NSLocalizedString("Filters", comment: "FilterTitle for tabBar")
        trackerViewController.tabBarItem = UITabBarItem(
            title: trackerTitle,
            image: UIImage(named: "trackerTabBar"),
            selectedImage: UIImage(systemName: "trackerTabBar"))
        statisticViewController.tabBarItem = UITabBarItem(
            title: statisticTitle,
            image: UIImage(named: "trackerTabBar"),
            selectedImage: UIImage(named: "trackerTabBar")
        )
    
        viewControllers = [trackerViewController, statisticViewController]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "clearWhite")
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(named: "clearWhite")
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
//        UITabBar.appearance().standardAppearance = tabBarAppearance
        
    }
}
