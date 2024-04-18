import Foundation

class Schedule{
    var days: [Bool]
    init(days: [Bool]) {
        self.days = days
    }
    
    func updateDay(index: Int, selected: Bool) {
        guard days.indices.contains(index) else { return }
        days[index] = selected
    }
}
