//
//  ScheduleTransformer.swift
//  Tracker
//
//  Created by Михаил  on 04.05.2024.
//

import Foundation

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
        guard let schedule = value as? Schedule else { return nil }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(schedule.days) {
            return encoded as NSData
        }
        return nil
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        let decoder = JSONDecoder()
        if let days = try? decoder.decode([Bool].self, from: data) {
            return Schedule(days: days)
        }
        return nil
    }
}


