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
    
    func updateTracker(trackerId: UUID, newCount: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        do {
            if let trackerToUpdate = try context.fetch(fetchRequest).first {
                trackerToUpdate.countOfDoneTrackers = Int32(newCount)
                try context.save()
            } else {
                print("No tracker found with the given ID to update.")
            }
        } catch {
            print("Failed to fetch or update tracker: \(error)")
        }
    }
    
    func insertNewCategory(title: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCategoriesCoreData> = TrackerCategoriesCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty { 
                let newCategory = TrackerCategoriesCoreData(context: context)
                newCategory.title = title
                saveContext() // Сохраняем контекст, если категория уникальна
            } else {
                print("Category \(title) already exists.")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
    
    func addOrUpdateTracker(tracker: Tracker, categoryTitle: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            let trackerEntity = results.first ?? TrackerCoreData(context: context)
            
            trackerEntity.id = tracker.id
            trackerEntity.name = tracker.name
            trackerEntity.emoji = tracker.emoji
            trackerEntity.color = Utility.encodeColor(tracker.color) 
            trackerEntity.scheduleData = Utility.encodeSchedule(tracker.schedule)
            trackerEntity.countOfDoneTrackers = Int32(tracker.countOfDoneTrackers)
            
            let categoryFetchRequest: NSFetchRequest<TrackerCategoriesCoreData> = TrackerCategoriesCoreData.fetchRequest()
            categoryFetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
            let categoryResults = try context.fetch(categoryFetchRequest)
            let categoryEntity = categoryResults.first ?? TrackerCategoriesCoreData(context: context)
            categoryEntity.title = categoryTitle
            categoryEntity.addToTrackers(trackerEntity)
            
            saveContext()
        } catch {
            print("Failed to fetch or update tracker: \(error)")
        }
    }
    
    func addTrackerRecord(trackerRecord: TrackerRecord) {
        let context = persistentContainer.viewContext
        let trackerRecordEntity = TrackerRecordCoreData(context: context)
        trackerRecordEntity.trackerId = trackerRecord.trackerId
        trackerRecordEntity.date = trackerRecord.date
        saveContext()
    }
    
    func removeTrackerRecord(trackerRecord: TrackerRecord) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerRecord.trackerId as CVarArg, trackerRecord.date as NSDate)
        
        do {
            if let trackerRecordToRemove = try context.fetch(fetchRequest).first {
                context.delete(trackerRecordToRemove)
                saveContext()
            } else {
                print("No tracker record found with the given ID and date to remove.")
            }
        } catch {
            print("Failed to fetch or remove tracker record: \(error)")
        }
    }
    
    func removeTrackerRecordBy(trackerId: UUID) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        
        do {
            if let trackerRecordToRemove = try context.fetch(fetchRequest).first {
                context.delete(trackerRecordToRemove)
                saveContext()
            } else {
                print("No tracker record found with the given ID to remove.")
            }
        } catch {
            print("Failed to fetch or remove tracker record: \(error)")
        }
    }
    
    func fetchCompletedTrackers() -> [TrackerRecordCoreData] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch completed trackers: \(error)")
            return []
        }
    }
    
    func updateTracker(_ tracker: Tracker, completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            if let trackerToUpdate = try context.fetch(fetchRequest).first {
                trackerToUpdate.isPinned = tracker.isPinned
                trackerToUpdate.countOfDoneTrackers = Int32(tracker.countOfDoneTrackers)
                trackerToUpdate.name = tracker.name
                trackerToUpdate.emoji = tracker.emoji
                trackerToUpdate.color = Utility.encodeColor(tracker.color)
                trackerToUpdate.scheduleData = Utility.encodeSchedule(tracker.schedule)
                try context.save()
                completion()  
            } else {
                print("No tracker found with the given ID to update.")
            }
        } catch {
            print("Failed to fetch or update tracker: \(error)")
        }
    }

    
}


