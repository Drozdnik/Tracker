import CoreData
import UIKit

class TrackerViewModel: NSObject {
    var onDataUpdated: (() -> Void)?
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }

    var count: Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         onDataUpdated?()
     }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        
        let color: UIColor = Utility.dataToColor(data: trackerCoreData.color as! NSData) ?? UIColor.black

        let schedule: Schedule? = Utility.dataToSchedule(data: trackerCoreData.scheduleData as! NSData)

        guard let unwrappedSchedule = schedule else {
            fatalError("Failed to decode schedule data")
        }

        return Tracker(id: trackerCoreData.id!, name: trackerCoreData.name!, color: color, emoji: trackerCoreData.emoji!, schedule: unwrappedSchedule, count: Int(trackerCoreData.count))
    }
    func fetchAllCategories() -> [TrackerCategory] {
        do {
            let categories = try managedObjectContext.fetch(TrackerCategoriesCoreData.fetchRequest()) as [TrackerCategoriesCoreData]
            return categories.map { convertToTrackerCategory(coreData: $0) }
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
            return []
        }
    }

    private func convertToTrackerCategory(coreData: TrackerCategoriesCoreData) -> TrackerCategory {
        let trackers = coreData.trackers as? Set<TrackerCoreData> ?? []

        let modelTrackers = trackers.compactMap { trackerCoreData -> Tracker? in
            guard let id = trackerCoreData.id,
                  let name = trackerCoreData.name,
                  let emoji = trackerCoreData.emoji,
                  let colorData = trackerCoreData.color as? NSData,
                  let scheduleData = trackerCoreData.scheduleData as? NSData,
                  let schedule = Utility.dataToSchedule(data: scheduleData) else {
                print("One of the required properties is nil")
                print("ID: \(trackerCoreData.id as Any), Name: \(trackerCoreData.name as Any), Emoji: \(trackerCoreData.emoji as Any)")
                print("Color Data: \(trackerCoreData.color as Any), Schedule Data: \(trackerCoreData.scheduleData as Any)")
                return nil
            }

            let color = Utility.dataToColor(data: colorData) ?? UIColor.black
            return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule, count: Int(trackerCoreData.count))
        }

        return TrackerCategory(title: coreData.title ?? "Unknown Title", trackers: modelTrackers)
    }

}

extension TrackerViewModel: NSFetchedResultsControllerDelegate {
}
