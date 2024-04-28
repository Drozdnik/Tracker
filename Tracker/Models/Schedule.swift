import Foundation

class Schedule{
    var days: [Bool]
    let dayNames = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"]
    
    init(days: [Bool]) {
        self.days = days
    }
    
    
    func updateDay(index: Int, selected: Bool) {
        guard days.indices.contains(index) else { return }
        days[index] = selected
    }
    
    func dayToShortDay() -> String{
        if days.allSatisfy({$0}){
            return "Каждый день"
        } else {
            var selectedDay: [String] = []
            for (index, isSelected) in days.enumerated() {
                if isSelected{
                    selectedDay.append(dayNames[index])
                }
            }
            return selectedDay.joined(separator: ", ")
        }
    }
}
