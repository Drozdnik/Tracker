import CoreData


final class TrackerStore {
    private var dataManager: DataManager
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    private(set) var allCategories: [TrackerCategory] = []
    private(set) var categories: [TrackerCategory] = []
    var currentDate: Date = Date()
    private(set) var completedTrackers: [TrackerRecord] = []

    init(dataManager: DataManager, managedObjectContext: NSManagedObjectContext) {
        self.dataManager = dataManager
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        self.completedTrackers = dataManager.fetchCompletedTrackers().map { TrackerRecord(trackerId: $0.trackerId!, date: $0.date!) }
    }

    func fetchAllCategories(completion: @escaping () -> Void) {
        let categories = dataManager.fetchCategories()
        self.allCategories = categories.map { convertToTrackerCategory(coreData: $0) }
        filterTrackersForCurrentDay()
        completion()
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
                return nil
            }
            return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule, countOfDoneTrackers: Int(trackerCoreData.countOfDoneTrackers))
        }
        return TrackerCategory(title: coreData.title ?? "Unknown Title", trackers: modelTrackers)
    }

    func updateTrackerCount(trackerId: UUID, newCount: Int, completion: (() -> Void)? = nil) {
        dataManager.updateTracker(trackerId: trackerId, newCount: newCount)
        filterTrackersForCurrentDay()
        completion?()
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
        }
    }

    func addCompletedTracker(record: TrackerRecord, completion: (() -> Void)? = nil) {
        completedTrackers.append(record)
        dataManager.addTrackerRecord(trackerRecord: record)
        completion?()
    }

    func removeCompletedTracker(at index: Int, completion: (() -> Void)? = nil) {
        if index >= 0 && index < completedTrackers.count {
            let record = completedTrackers[index]
            completedTrackers.remove(at: index)
            dataManager.removeTrackerRecord(trackerRecord: record)
        }
        completion?()
    }
}

