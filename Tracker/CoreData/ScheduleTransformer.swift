import Foundation

@objc(ScheduleTransformer)
class ScheduleTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let schedule = value as? Schedule else {
            print("Failed to cast Schedule")
            return nil
        }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(schedule)
            return data
        } catch {
            print("Failed to encode schedule: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            print("Failed to cast NSData to Data")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let schedule = try decoder.decode(Schedule.self, from: data)
            return schedule
        } catch {
            print("Failed to decode schedule: \(error)")
            return nil
        }
    }
}

