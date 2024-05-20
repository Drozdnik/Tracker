import Foundation

class ChooseTrackerTitleViewModel {
    var categories: [String] = [] {
        didSet {
            onCategoriesUpdated?()
            saveCategoriesToCoreData()
        }
    }
    var selectedCategory: String?
    
    var onCategoriesUpdated: (() -> Void)?
    
    private func saveCategoriesToCoreData() {
        guard let lastCategory = categories.last else { return }

        DataManager.shared.insertNewCategory(title: lastCategory)
    }

    func loadCategoriesFromCoreData() {
        let fetchedCategories = DataManager.shared.fetchCategories().compactMap { $0.title }
        DispatchQueue.main.async { [weak self] in
            self?.categories = fetchedCategories
            self?.onCategoriesUpdated?()  
        }
    }
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
