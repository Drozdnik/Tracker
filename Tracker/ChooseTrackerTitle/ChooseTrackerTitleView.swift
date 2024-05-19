import UIKit

protocol selectedCategoryPassDelegate: AnyObject{
    func selectedCategoryPass(selectedCategory: String)
}

final class ChooseTrackerTitleView: UIViewController {
    private let tableView = UITableView()
    weak var delegate: selectedCategoryPassDelegate?
    var categories: [String] = [] {
        didSet {
            imageForNoCategories.isHidden = !categories.isEmpty
            labelForNoCategories.isHidden = !categories.isEmpty
            tableView.reloadData()
        }
    }
    
    private var selectedCategory: String?
    
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
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
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
        if let selectedCategory{
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

extension ChooseTrackerTitleView: addCategoryDelegate {
    func didAddCategory(name: String) {
        categories.append(name)
        tableView.reloadData()
    }
}

extension ChooseTrackerTitleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = categories[indexPath.row]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
}

extension ChooseTrackerTitleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCategory == categories[indexPath.row] {
            deselectCategory()
        } else {
            selectedCategory = categories[indexPath.row]
            tableView.reloadData()
        }
    }
    
    func deselectCategory() {
        selectedCategory = nil
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

