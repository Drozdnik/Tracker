//
//  Utility.swift
//  Tracker
//
//  Created by Михаил  on 06.05.2024.
//

import Foundation
import UIKit

class Utility {
    static func encodeColor(_ color: UIColor) -> String {
        return color.toHexString()
    }

    static func decodeColor(_ colorString: String) -> UIColor? {
        guard let color = UIColor(hex: colorString) else {
            print("Failed to convert string to UIColor")
            return nil
        }
        return color
    }

    static func encodeSchedule(_ schedule: Schedule) -> String {
        let dayStrings = schedule.days.map { $0 ? "1" : "0" }
        return dayStrings.joined(separator: ",")
    }

    static func decodeSchedule(_ scheduleString: String) -> Schedule? {
        let dayBools = scheduleString.split(separator: ",").map { $0 == "1" }
        if dayBools.count == 7 { 
            return Schedule(days: dayBools)
        } else {
            print("Error: Schedule string is not properly formatted")
            return nil
        }
    }
}
