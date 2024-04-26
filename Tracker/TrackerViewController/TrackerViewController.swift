import Foundation
import UIKit


final class TrackerViewController: UIViewController{
    let noTracksLabel = UILabel()
    
    var currentDate: Date = Date()
    var completedTrackers: [TrackerRecord] = []
    var allCategories: [TrackerCategory] = []
    var categories: [TrackerCategory]  = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        addSubViews()
        configureConstraints()
        configureDatePicker()
        filterTrakersForCurrentDay()
        collectionView.reloadData()
    }
    
    
    private func addSubViews(){
        view.addSubview(noTracksLabel)
        view.addSubview(imageForNoTracks)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
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
            collectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -2),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 115),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
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
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private func configureDatePicker() {
        let dateButton = UIDatePicker()
        dateButton.datePickerMode = .date
        dateButton.locale = Locale(identifier: "ru_RU")
        dateButton.timeZone = TimeZone(identifier: "Europe/Moscow")
        dateButton.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
        
        let currentDate = Date()
        dateButton.setDate(currentDate, animated: false)
        
        let calendar = Calendar(identifier: .gregorian)
        if let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate),
           let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate) {
            dateButton.minimumDate = minDate
            dateButton.maximumDate = maxDate
        }
    }
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "BlueForFilter")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private func configureNavigationBar(){
        navigationItem.title = "Трекеры"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
        
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "GrayForNavBar")
        searchController.searchBar.searchTextField.layer.cornerRadius = 6
        searchController.searchBar.searchTextField.clipsToBounds = true
        searchController.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true // или false если не хотим скрывать
    }
    
    private func isDate(_ date: Date, matchesScheduleOf tracker: Tracker) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return tracker.schedule.days[weekday - 2] // вот тут проверить что вернет
    }
    
    func filterTrakersForCurrentDay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.firstWeekday = 2 // Понедельник как первый день недели
        calendar.timeZone = TimeZone(identifier: "Europe/Moscow") ?? TimeZone.current
        
        categories = allCategories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let isIrregular = tracker.schedule.days.allSatisfy({ !$0 })
                let weekdayIndex = (calendar.component(.weekday, from: currentDate) + 5) % 7
                return isIrregular ? false : tracker.schedule.days[weekdayIndex]
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
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
            self.allCategories = self.categories
            filterTrakersForCurrentDay()
            self.collectionView.reloadData()
            self.dismiss(animated: true)
            configureNoTracksLabel()
        }
        present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        filterTrakersForCurrentDay()
        collectionView.reloadData()
    }
    
    
    @objc private func filterButtonTapped() {
        // Действие при нажатии на кнопку
        print("Фильтр нажат")
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
        cell.indexPath = indexPath

        cell.onIncrementCount = { [weak self] indexPath in
            guard let self = self else { return }
            let trackerItem = self.categories[indexPath.section].trackers[indexPath.item]

            // Проверяем, является ли дата будущей
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date()) // Получаем начало текущего дня для точного сравнения
            let currentDateStart = calendar.startOfDay(for: self.currentDate) // Получаем начало дня currentDate для точного сравнения
            let isFutureDate = calendar.compare(currentDateStart, to: today, toGranularity: .day) == .orderedDescending

            // Если дата будущая, ничего не делаем
            if isFutureDate {
                return
            }

            if let index = self.completedTrackers.firstIndex(where: { $0.trackerId == trackerItem.id && Calendar.current.isDate($0.date, inSameDayAs: self.currentDate) }) {
                trackerItem.count -= 1
                self.completedTrackers.remove(at: index)
            } else {

                trackerItem.count += 1
                let newRecord = TrackerRecord(trackerId: trackerItem.id, date: self.currentDate)
                self.completedTrackers.append(newRecord)
            }
            self.collectionView.reloadItems(at: [indexPath])
        }

        cell.configureWith(tracker: tracker, completedTrackers: self.completedTrackers, currentDate: self.currentDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            assertionFailure("Header error")
            return UICollectionReusableView()
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
