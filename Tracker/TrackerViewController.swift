import Foundation
import UIKit

final class TrackerViewController: UIViewController{
    let noTracksLabel = UILabel()
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
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
        navigationItem.title = "Трекеры"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: Date())
        
        // Создание кнопки для даты
        let dateButton = UIButton(type: .system)
        dateButton.setTitle(dateString, for: .normal)
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        dateButton.backgroundColor = UIColor(named: "GrayForNavBar")
        dateButton.layer.cornerRadius = 8
        dateButton.layer.masksToBounds = true
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.addTarget(self, action: #selector(dateTapped), for: .touchUpInside)
        
        let dateItem = UIBarButtonItem(customView: dateButton)
        navigationItem.rightBarButtonItem = dateItem
        
        let maxWidthConstraint = dateButton.widthAnchor.constraint(equalToConstant: 77)
        maxWidthConstraint.isActive = true
        
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.placeholder = "Поиск"
            searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "GrayForNavBar")
            searchController.searchBar.searchTextField.layer.cornerRadius = 6
            searchController.searchBar.searchTextField.clipsToBounds = true
            searchController.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true // или false если не хотим скрывать
    }
    
    @objc private func addTapped() {
        let vc = ChooseTypeOfTracker()
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
    
    @objc private func dateTapped() {
        
    }
    
}
