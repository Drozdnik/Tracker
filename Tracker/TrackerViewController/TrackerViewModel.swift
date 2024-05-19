import Foundation

final class TrackerViewModel: NSObject {
    var onDataUpdated: (() -> Void)?
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
            self.onDataUpdated?()
        }
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
}
