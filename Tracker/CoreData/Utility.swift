//
//  Utility.swift
//  Tracker
//
//  Created by Михаил  on 06.05.2024.
//

import Foundation
import UIKit

class Utility {
    static func colorToData(color: UIColor) -> NSData? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData
        } catch {
            print("Failed to convert color to NSData")
            return nil
        }
    }
    
    static func dataToColor(data: NSData) -> UIColor? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as Data) as? UIColor
        } catch {
            print("Failed to convert NSData to UIColor")
            return nil
        }
    }
    
    static func dataToSchedule(data: NSData) -> Schedule? {
        let decoder = JSONDecoder()
        do {
            let schedule = try decoder.decode(Schedule.self, from: data as Data)
            return schedule
        } catch {
            print("Failed to decode Schedule: \(error)")
            return nil
        }
    }
    
    static func encodeColor(_ color: UIColor) -> String {
        return color.toHexString()
    }

    static func decodeColor(_ colorString: String) -> UIColor {
        return UIColor(hex: colorString) ?? UIColor.black // Возвращаем черный цвет как fallback
    }

    static func encodeSchedule(_ schedule: Schedule) -> String {
        let dayStrings = schedule.days.map { $0 ? "1" : "0" } // Преобразуем [true, false] в ["1", "0"]
        return dayStrings.joined(separator: ",") // Объединяем в строку через запятую
    }

    static func decodeSchedule(_ scheduleString: String) -> Schedule {
        let dayStrings = scheduleString.split(separator: ",").map { $0 == "1" } // Разделяем строку и преобразуем в [Bool]
        return Schedule(days: dayStrings)
    }
}
