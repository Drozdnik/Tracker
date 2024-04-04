import Foundation
import UIKit

final class Tracker: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func addSubViews(){
        view.addSubview(addButton)
    }
    
    private func configureConstraints(){
        
    }
    
    private func createLabel(_ text: String, size: CGFloat, color: UIColor = .white, font:UIFont = UIFont.boldSystemFont(ofSize: 13)) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton.systemButton(
            with: UIImage(systemName: "plus")!,
            target: self,
            action: #selector(didTapAddButton)
        )
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    @objc private func didTapAddButton(){
        
    }
}
