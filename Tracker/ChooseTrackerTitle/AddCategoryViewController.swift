import UIKit

protocol AddCategoryDelegate: AnyObject {
    func didAddCategory(name: String)
}

final class AddCategoryViewController: UIViewController {
    weak var delegate: AddCategoryDelegate?
    private let viewModel = AddCategoryViewModel()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.borderStyle = .none
        
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor(named: "GrayForTableViews")?.withAlphaComponent(0.3)
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17)
        
        textField.setLeftPaddingPoints(16)
        textField.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,weight: .bold)
        button.backgroundColor = .gray
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        configureConstraints()
        configureNavBar()
        bindViewModel()
        textField.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onCategoryNameUpdated = { [weak self] name in
            self?.doneButton.isEnabled = !name.isEmpty
            self?.doneButton.backgroundColor = name.isEmpty ? .gray : .black
        }
    }
    
    private func addSubviews() {
        view.addSubviews([textField, doneButton])
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureNavBar() {
        navigationItem.title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    @objc private func doneButtonTapped() {
        guard let categoryName = textField.text, !categoryName.isEmpty else { return }
        delegate?.didAddCategory(name: categoryName)
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChangeSelection() {
        viewModel.categoryName = textField.text ?? ""
    }
}

extension AddCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
