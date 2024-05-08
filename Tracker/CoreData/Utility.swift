//
//  Utility.swift
//  Tracker
//
//  Created by Михаил  on 06.05.2024.
//

import Foundation
import UIKit

class Utility {
    // Convert UIColor to Hex String
    static func encodeColor(_ color: UIColor) -> String {
        return color.toHexString()
    }

    // Convert Hex String to UIColor
    static func decodeColor(_ colorString: String) -> UIColor? {
        guard let color = UIColor(hex: colorString) else {
            print("Failed to convert string to UIColor")
            return nil
        }
        return color
    }

    // Convert Schedule to String
    static func encodeSchedule(_ schedule: Schedule) -> String {
        let dayStrings = schedule.days.map { $0 ? "1" : "0" } // Convert [Bool] to ["1", "0"]
        return dayStrings.joined(separator: ",") // Join with commas
    }

    // Convert String to Schedule
    static func decodeSchedule(_ scheduleString: String) -> Schedule? {
        let dayBools = scheduleString.split(separator: ",").map { $0 == "1" } // Split by commas and convert to [Bool]
        if dayBools.count == 7 { // There should be exactly 7 days
            return Schedule(days: dayBools)
        } else {
            print("Error: Schedule string is not properly formatted")
            return nil
        }
    }
}
