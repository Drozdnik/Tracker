import Foundation
import CoreData
import UIKit

class TrackerViewModel: NSObject {
    var onDataUpdated: (() -> Void)?
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    private let managedObjectContext: NSManagedObjectContext
    private(set) var allCategories: [TrackerCategory] = []
    private(set) var categories: [TrackerCategory] = []
    var currentDate: Date = Date()
    var completedTrackers: [TrackerRecord] = []

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
        
        let color = trackerCoreData.color.flatMap(Utility.decodeColor) ?? UIColor.black
        
        let schedule = trackerCoreData.scheduleData.flatMap(Utility.decodeSchedule) ?? Schedule(days: [false, false, false, false, false, false, false])
        
        return Tracker(id: trackerCoreData.id!, name: trackerCoreData.name!, color: color, emoji: trackerCoreData.emoji!, schedule: schedule, countOfDoneTrackers: Int(trackerCoreData.countOfDoneTrackers))
    }

    func fetchAllCategories(completion: @escaping () -> Void) {
        do {
            let categories = try managedObjectContext.fetch(TrackerCategoriesCoreData.fetchRequest()) as [TrackerCategoriesCoreData]
            self.allCategories = categories.map { convertToTrackerCategory(coreData: $0) }
            filterTrackersForCurrentDay()
            completion()
        } catch {
            print("Error loading categories: \(error)")
            completion()
        }
    }

    private func convertToTrackerCategory(coreData: TrackerCategoriesCoreData) -> TrackerCategory {
        let trackers = coreData.trackers as? Set<TrackerCoreData> ?? []
        
        let modelTrackers = trackers.compactMap { trackerCoreData -> Tracker? in
            guard let id = trackerCoreData.id,
                  let name = trackerCoreData.name,
                  let emoji = trackerCoreData.emoji,
                  let colorString = trackerCoreData.color,
                  let scheduleString = trackerCoreData.scheduleData,
                  let color = Utility.decodeColor(colorString),
                  let schedule = Utility.decodeSchedule(scheduleString) else {
                print("One of the required properties is nil")
                print("ID: \(String(describing: trackerCoreData.id)), Name: \(String(describing: trackerCoreData.name)), Emoji: \(String(describing: trackerCoreData.emoji))")
                print("Color Data: \(String(describing: trackerCoreData.color)), Schedule Data: \(String(describing: trackerCoreData.scheduleData))")
                return nil
            }
            
            return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule, countOfDoneTrackers: Int(trackerCoreData.countOfDoneTrackers))
        }
        
        return TrackerCategory(title: coreData.title ?? "Unknown Title", trackers: modelTrackers)
    }

    func filterTrackersForCurrentDay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = TimeZone(identifier: "Europe/Moscow") ?? TimeZone.current
        let today = calendar.startOfDay(for: Date())
        let isToday = Calendar.current.isDate(currentDate, inSameDayAs: today)
        
        categories = allCategories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let isIrregular = tracker.schedule.days.allSatisfy({ !$0 })
                let weekdayIndex = (calendar.component(.weekday, from: currentDate) + 5) % 7
                
                return isIrregular ? isToday : tracker.schedule.days[weekdayIndex]
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        onDataUpdated?()
    }

    func updateCurrentDate(_ date: Date) {
        currentDate = date
        filterTrackersForCurrentDay()
    }

    func incrementTrackerCount(at indexPath: IndexPath) {
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let currentDateStart = calendar.startOfDay(for: currentDate)
        let isFutureDate = calendar.compare(currentDateStart, to: today, toGranularity: .day) == .orderedDescending

        if isFutureDate {
            return
        }

        var newCount = tracker.countOfDoneTrackers
        if let index = completedTrackers.firstIndex(where: { $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate) }) {
            tracker.countOfDoneTrackers -= 1
            newCount = tracker.countOfDoneTrackers
            completedTrackers.remove(at: index)
        } else {
            tracker.countOfDoneTrackers += 1
            newCount = tracker.countOfDoneTrackers
            let newRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            completedTrackers.append(newRecord)
        }
        DataManager.shared.updateTracker(trackerId: tracker.id, newCount: newCount)
        filterTrackersForCurrentDay()
    }
}

extension TrackerViewModel: NSFetchedResultsControllerDelegate {
}
