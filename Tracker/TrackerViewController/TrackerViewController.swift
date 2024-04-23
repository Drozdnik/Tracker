import Foundation
import UIKit


final class TrackerViewController: UIViewController{
    let noTracksLabel = UILabel()
//    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var categories: [TrackerCategory] = [TrackerCategory(title: "Важноеска", trackers: [
       Tracker(id: UUID(), name: "123123", color: .blue, emoji: "🌟", schedule: Schedule(days: [true])),
       Tracker(id: UUID(), name: "456456", color: .green, emoji: "🌟", schedule: Schedule(days: [true])),
       Tracker(id: UUID(), name: "456456", color: .red, emoji: "🌟", schedule: Schedule(days: [true])),
    ])]
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
        view.addSubview(collectionView)
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
            noTracksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    private func configureNoTracksLabel(){
        if categories.isEmpty  {
            noTracksLabel.text = "Что будем отслеживать?"
            noTracksLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            noTracksLabel.textAlignment = .center
            noTracksLabel.translatesAutoresizingMaskIntoConstraints = false
        } else {
            noTracksLabel.isHidden = true
            imageForNoTracks.isHidden = true
        }
    }
    
    private lazy var imageForNoTracks: UIImageView = {
        let image = UIImage(named: "NoTracks")
        let noTracksImage = UIImageView(image: image)
        noTracksImage.translatesAutoresizingMaskIntoConstraints = false
        return noTracksImage
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 9) // Вот тут похоже придется все поменять
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private func configureNavigationBar(){
        navigationItem.title = "Трекеры"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
        
        // Создание кнопки для даты
        let dateButton = UIDatePicker()
        dateButton.datePickerMode = .date
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
        dateButton.locale = Locale(identifier: "ru_RU")
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        dateButton.minimumDate = minDate
        dateButton.maximumDate = maxDate
        dateButton.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
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
        
        vc.newHabbitComplete = { [weak self] title, tracker in
            guard let self else {return}
            if let index = self.categories.firstIndex(where: { $0.title == title }) {
                self.categories[index].trackers.append(tracker)
            } else {
                let newCategory = TrackerCategory(title: title, trackers: [tracker])
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
            self.dismiss(animated: true)
        }
        present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}

extension TrackerViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackerCollectionViewCell
           let tracker = categories[indexPath.section].trackers[indexPath.row]
          cell.configureWith(tracker: tracker)
           return cell
       }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionHeaderView.identifier,
            for: indexPath
        ) as! CollectionHeaderView

        let categoryTitle = categories[indexPath.section].title
        headerView.configure(with: categoryTitle)

        return headerView
    }
    
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 9 , height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
