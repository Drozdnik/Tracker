import Foundation

class AddCategoryViewModel {
    var categoryName: String = "" {
        didSet {
            onCategoryNameUpdated?(categoryName)
        }
    }
    
    var onCategoryNameUpdated: ((String) -> Void)?
}
