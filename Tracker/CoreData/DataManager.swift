import CoreData
import UIKit
class DataManager {
    static let shared = DataManager()
    private let persistentContainer: NSPersistentContainer
    
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TrackerDB")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Failed to load stores: \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Failed to save context: \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func insertNewCategory(title: String) {
        let context = persistentContainer.viewContext
        let newCategory = TrackerCategoriesCoreData(context: context)
        newCategory.title = title
        saveContext()
    }

    func fetchCategories() -> [TrackerCategoriesCoreData] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCategoriesCoreData> = TrackerCategoriesCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
    func addTrackerToCategory(trackerName: String, categoryName: String) {
        let context = persistentContainer.viewContext
        let categoryFetch: NSFetchRequest<TrackerCategoriesCoreData> = TrackerCategoriesCoreData.fetchRequest()
        categoryFetch.predicate = NSPredicate(format: "title == %@", categoryName)

        if let category = (try? context.fetch(categoryFetch))?.first {
            // Категория существует, добавляем трекер
            let newTracker = Tracker(context: context)
            newTracker.name = trackerName
            newTracker.category = category
            saveContext()
        } else {
            // Создаем новую категорию и трекер
            let newCategory = TrackerCategoriesCoreData(context: context)
            newCategory.title = categoryName

            let newTracker = Tracker(context: context)
            newTracker.name = trackerName
            newTracker.category = newCategory
            
            saveContext()
        }
    }
}

