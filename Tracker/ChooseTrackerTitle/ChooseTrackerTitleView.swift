import UIKit

protocol SelectedCategoryPassDelegate: AnyObject {
    func selectedCategoryPass(selectedCategory: String)
}

final class ChooseTrackerTitleView: UIViewController {
    private let tableView = UITableView()
    weak var delegate: SelectedCategoryPassDelegate?
    private let viewModel = ChooseTrackerTitleViewModel()

    private lazy var imageForNoCategories: UIImageView = {
        let image = UIImage(named: "NoTracks")
        let noTracksImage = UIImageView(image: image)
        noTracksImage.translatesAutoresizingMaskIntoConstraints = false
        return noTracksImage
    }()
    
    private lazy var labelForNoCategories: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\n объеденить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupTableView()
        addSubViews()
        configureConstraints()
        bindViewModel()
        viewModel.loadCategoriesFromCoreData()
    }
    
    func updateUI(){
         let hasCategories = !viewModel.categories.isEmpty
         imageForNoCategories.isHidden = hasCategories
         labelForNoCategories.isHidden = hasCategories
         tableView.reloadData()
     }
    
    private func bindViewModel() {
        viewModel.onCategoriesUpdated = { [weak self] in
            guard let self = self else { return }
            updateUI()
        }
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = true
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        view.addSubview(tableView)
    }
    
    private func addSubViews() {
        view.addSubviews([tableView, imageForNoCategories, labelForNoCategories, addButton])
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageForNoCategories.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageForNoCategories.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageForNoCategories.widthAnchor.constraint(equalToConstant: 80),
            imageForNoCategories.heightAnchor.constraint(equalToConstant: 80),
            
            labelForNoCategories.topAnchor.constraint(equalTo: imageForNoCategories.bottomAnchor, constant: 8),
            labelForNoCategories.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelForNoCategories.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16)
        ])
    }
    
    private func configureNavBar() {
        navigationItem.title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    @objc private func addCategoryTapped() {
        if let selectedCategory = viewModel.selectedCategory {
            delegate?.selectedCategoryPass(selectedCategory: selectedCategory)
            dismiss(animated: true)
        } else {
            let vc = AddCategoryViewController()
            vc.delegate = self
            let navigationController = UINavigationController(rootViewController: vc)
            present(navigationController, animated: true)
        }
    }
}

extension ChooseTrackerTitleView: AddCategoryDelegate {
    func didAddCategory(name: String) {
        viewModel.addCategory(name)
    }
}

extension ChooseTrackerTitleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = viewModel.category(at: indexPath.row)
        let isSelected = category == viewModel.selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 0
        cell.layer.maskedCorners = []
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}

extension ChooseTrackerTitleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
