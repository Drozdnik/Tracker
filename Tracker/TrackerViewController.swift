import Foundation
import UIKit

final class TrackerViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    private func addSubViews(){
        
    }
    
    private func configureConstraints(){
        
    }
    
    private func configureNavigationBar(){
        let customNavBar = NavigationBarCustom()
          customNavBar.translatesAutoresizingMaskIntoConstraints = false
        
          // Добавляем customNavBar как subview к navigationBar
          navigationController?.navigationBar.addSubview(customNavBar)
        NSLayoutConstraint.activate([
            customNavBar.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor),
            customNavBar.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor),
            customNavBar.topAnchor.constraint(equalTo: navigationController!.navigationBar.topAnchor)
        ])
    }
}
