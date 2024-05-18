import UIKit

final class TrackerViewController: UIViewController {
    let noTracksLabel = UILabel()
    var viewModel: TrackerViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            viewModel = TrackerViewModel(managedObjectContext: managedObjectContext)
        }

        viewModel.onDataUpdated = { [weak self] in
            self?.collectionView.reloadData()
            self?.configureNoTracksLabel()
        }
        
        showOnboardingIfNeeded()
        configureNavigationBar()
        addSubViews()
        configureConstraints()
        configureDatePicker()
        viewModel.fetchAllCategories {
            self.viewModel.filterTrackersForCurrentDay()
        }
    }
    
    private func showOnboardingIfNeeded(){
        if UserDefaults.standard.bool(forKey: "HasViewedOnboarding") == false {
            let onboardingVC = OnBoardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: true, completion: nil)
        }
    }
    private func addSubViews() {
        view.addSubview(noTracksLabel)
        view.addSubview(imageForNoTracks)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
    }

    private func configureConstraints() {
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

    private func configureNoTracksLabel() {
        noTracksLabel.isHidden = viewModel.categories.isEmpty ? false : true
        imageForNoTracks.isHidden = viewModel.categories.isEmpty ? false : true
        noTracksLabel.text = "Что будем отслеживать?"
        noTracksLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        noTracksLabel.textAlignment = .center
        noTracksLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureNavigationBar() {
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
    
    @objc private func addTapped() {
        let vc = ChooseTypeOfTracker()
        let navigationController = UINavigationController(rootViewController: vc)
        
        vc.newHabbitComplete = { [weak self] title, tracker in
            guard let self = self else { return }
            DataManager.shared.addOrUpdateTracker(tracker: tracker, categoryTitle: title)
            
            self.viewModel.fetchAllCategories {
                self.viewModel.filterTrackersForCurrentDay()
            }
            self.dismiss(animated: true)
            self.configureNoTracksLabel()
        }
        present(navigationController, animated: true)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.updateCurrentDate(sender.date)
    }

    @objc private func filterButtonTapped() {
        print("Фильтр нажат")
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackerCollectionViewCell
        let tracker = viewModel.categories[indexPath.section].trackers[indexPath.row]
        cell.indexPath = indexPath

        cell.onIncrementCount = { [weak self] indexPath in
            self?.viewModel.incrementTrackerCount(at: indexPath)
        }

        cell.configureWith(tracker: tracker, completedTrackers: viewModel.completedTrackers, currentDate: viewModel.currentDate)
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
        
        let categoryTitle = viewModel.categories[indexPath.section].title
        headerView.configure(with: categoryTitle)
        
        return headerView
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
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
