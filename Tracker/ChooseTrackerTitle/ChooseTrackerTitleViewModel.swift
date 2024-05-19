import Foundation

class ChooseTrackerTitleViewModel {
    var categories: [String] = [] {
        didSet {
            onCategoriesUpdated?()
        }
    }
    var selectedCategory: String?
    
    var onCategoriesUpdated: (() -> Void)?
    
    var categoriesCount: Int {
        return categories.count
    }
    
    func category(at index: Int) -> String {
        return categories[index]
    }
    
    func addCategory(_ name: String) {
        categories.append(name)
    }
    
    func selectCategory(at index: Int) {
        if selectedCategory == categories[index] {
            selectedCategory = nil
        } else {
            selectedCategory = categories[index]
        }
    }
}
