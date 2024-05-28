import Foundation

class Schedule: Codable, Equatable {
    var days: [Bool]
    let dayNames = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"]

    init(days: [Bool]) {
        self.days = days
    }

    // Реализация протокола Equatable
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.days == rhs.days
    }

    // Декодирующий инициализатор требуется для соответствия протоколу Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        days = try container.decode([Bool].self, forKey: .days)
    }

    // Метод encode(to:) для кодирования
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(days, forKey: .days)
    }

    // CodingKeys для указания, какие свойства кодируются/декодируются
    enum CodingKeys: CodingKey {
        case days
    }
    
    func updateDay(index: Int, selected: Bool) {
        guard days.indices.contains(index) else { return }
        days[index] = selected
    }
    
    func dayToShortDay() -> String {
        if days.allSatisfy({ $0 }) {
            return "Каждый день"
        } else {
            return days.enumerated().filter { $0.element }.map { dayNames[$0.offset] }.joined(separator: ", ")
        }
    }
}
