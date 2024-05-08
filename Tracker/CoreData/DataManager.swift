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
                    trackerToUpdate.count = Int32(newCount)
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
                trackerEntity.count = Int32(tracker.count)

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



        }


