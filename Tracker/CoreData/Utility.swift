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
}
