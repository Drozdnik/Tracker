
import UIKit

final class ChooseTrackerTitleView: UIViewController{
    var categories: [String] = []{
        didSet{
            imageForNoCategories.isHidden = !categories.isEmpty
            labelForNoCategories.isHidden = !categories.isEmpty
        }
    }
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
        title = "Категория"
        
        addSubViews()
        configureConstraints()
    }
    
    private func addSubViews(){
        view.addSubviews([imageForNoCategories, labelForNoCategories, addButton])
    }
    
    private func configureConstraints(){
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
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func addCategoryTapped(){
        
    }
}

