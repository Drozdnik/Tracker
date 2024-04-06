import Foundation
import UIKit

final class TrackerViewController: UIViewController{
    let noTracksLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        addSubViews()
        configureConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(noTracksLabel)
        view.addSubview(imageForNoTracks)
    }
    
    private func configureConstraints(){
        configureNoTracksLabel()
        NSLayoutConstraint.activate([
            imageForNoTracks.heightAnchor.constraint(equalToConstant: 80),
            imageForNoTracks.widthAnchor.constraint(equalToConstant: 80),
            imageForNoTracks.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageForNoTracks.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            noTracksLabel.topAnchor.constraint(equalTo: imageForNoTracks.bottomAnchor, constant: 8),
            noTracksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noTracksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNoTracksLabel(){
        noTracksLabel.text = "Что будем отслеживать?"
        noTracksLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        noTracksLabel.textAlignment = .center
        noTracksLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var imageForNoTracks: UIImageView = {
        let image = UIImage(named: "NoTracks")
        let noTracksImage = UIImageView(image: image)
        noTracksImage.translatesAutoresizingMaskIntoConstraints = false
        return noTracksImage
    }()
    
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
