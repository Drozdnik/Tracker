import Foundation

final class TrackerViewModel: NSObject {
    var onDataUpdated: (() -> Void)?
    
    
    var allCategories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var trackerStore: TrackerStore
    
    init(trackerStore: TrackerStore) {
        self.trackerStore = trackerStore
    }
    
    var categories: [TrackerCategory] {
        return trackerStore.categories
    }
    
    var completedTrackers: [TrackerRecord] {
        return trackerStore.completedTrackers
    }
    
    var currentDate: Date {
        return trackerStore.currentDate
    }
    
    func fetchAllCategories() {
        trackerStore.fetchAllCategories {
            self.allCategories = self.trackerStore.categories
            self.prepareCategories()
        }
    }

    func prepareCategories() {
        var newCategories: [TrackerCategory] = []
        var pinnedTrackers: [Tracker] = []

        for category in self.allCategories {
            var regularTrackers: [Tracker] = []
            for tracker in category.trackers {
                if tracker.isPinned {
                    pinnedTrackers.append(tracker)
                } else {
                    regularTrackers.append(tracker)
                }
            }
            if !regularTrackers.isEmpty {
                newCategories.append(TrackerCategory(title: category.title, trackers: regularTrackers))
            }
        }

        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(title: "Закреплённые", trackers: pinnedTrackers)
            newCategories.insert(pinnedCategory, at: 0)
        }

        filteredCategories = newCategories
        onDataUpdated?()
    }

    private func applyFilters(searchText: String = "") {
            let nonEmptyCategories = allCategories.filter { !$0.trackers.isEmpty }
            
            if searchText.isEmpty {
                filteredCategories = nonEmptyCategories
            } else {
                filteredCategories = nonEmptyCategories.filter {
                    $0.title.lowercased().contains(searchText.lowercased()) ||
                    $0.trackers.contains(where: { $0.name.lowercased().contains(searchText.lowercased()) })
                }
            }
            onDataUpdated?()
        }
    
    
    func filterContentForSearchText(_ searchText: String) {
        applyFilters(searchText: searchText)
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
            newCount -= 1
            tracker.countOfDoneTrackers = newCount
            trackerStore.removeCompletedTracker(at: index) { [weak self] in
                self?.onDataUpdated?()
            }
        } else {
            newCount += 1
            tracker.countOfDoneTrackers = newCount
            let newRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            trackerStore.addCompletedTracker(record: newRecord) { [weak self] in
                self?.onDataUpdated?()
            }
        }
        trackerStore.updateTrackerCount(trackerId: tracker.id, newCount: newCount) { [weak self] in
            self?.onDataUpdated?()
        }
    }
    
    func updateCurrentDate(_ date: Date) {
        trackerStore.currentDate = date
        trackerStore.filterTrackersForCurrentDay()
        onDataUpdated?()
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        trackerStore.deleteTracker(trackerId: tracker.id) { [weak self] success in
            if success {
                self?.fetchAllCategories()
                self?.onDataUpdated?()
            }
        }
    }
    
    func pinTracker(at indexPath: IndexPath) {
        guard indexPath.section < categories.count, indexPath.row < categories[indexPath.section].trackers.count else { return }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = true
        updateTracker(tracker, shouldRefreshCategories: true) { success in
            if success {
                print("Tracker successfully pinned")
            }
        }
    }

    func unpinTracker(at indexPath: IndexPath) {
        guard indexPath.section < categories.count, indexPath.row < categories[indexPath.section].trackers.count else { return }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = false
        updateTracker(tracker, shouldRefreshCategories: true) { success in
            if success {
                print("Tracker successfully unpinned")
            }
        }
    }

    
    func updateTracker(_ tracker: Tracker, shouldRefreshCategories: Bool, completion: @escaping (Bool) -> Void) {
        trackerStore.updateTracker(tracker) { success in
            if success && shouldRefreshCategories {
                self.fetchAllCategories()
            }
            completion(success)
        }
    }
}

extension TrackerViewModel {
    func filterForSelectedDate() {
        trackerStore.filterTrackersForCurrentDay()
           onDataUpdated?()
    }
    
    func filterCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        filteredCategories = allCategories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                completedTrackers.contains(where: { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: today) })
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        onDataUpdated?()
    }

    func filterNotCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        filteredCategories = allCategories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                !completedTrackers.contains(where: { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: today) })
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        onDataUpdated?()
    }

    func clearFilter() {
        filteredCategories = allCategories.filter { !$0.trackers.isEmpty }
        onDataUpdated?()
    }
}

