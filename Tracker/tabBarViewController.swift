import Foundation
import UIKit

final class TabBarViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController(){
        let tracker = TrackerViewController()
        let statistic = StatisticViewController()
        
        
        let trackerViewController = UINavigationController(rootViewController: tracker)
        trackerViewController.navigationBar.prefersLargeTitles = true
        let statisticViewController = UINavigationController(rootViewController: statistic)
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackerTabBar"),
            selectedImage: UIImage(systemName: "trackerTabBar"))
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "trackerTabBar"),
            selectedImage: UIImage(named: "trackerTabBar")
        )
    
        viewControllers = [trackerViewController, statisticViewController]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
    }
}
