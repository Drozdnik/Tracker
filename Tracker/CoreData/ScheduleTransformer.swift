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
            // Печать данных после кодирования
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Encoded JSON: \(jsonString)")
            }
            return data as NSData
        } catch {
            print("Failed to encode schedule: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            print("Failed to cast NSData")
            return nil
        }
        // Печать данных в строковом формате для проверки
        let jsonString = String(data: data, encoding: .utf8) ?? "Empty or corrupt data"
        print("Decoding JSON: \(jsonString)")

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

