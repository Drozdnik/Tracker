//
//  ColorTransformer.swift
//  Tracker
//
//  Created by Михаил  on 04.05.2024.
//

import Foundation
import UIKit
@objc(ColorTransformer)
class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else {
            print("Failed to cast UIColor")
            return nil
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            print("Successfully converted UIColor to NSData")
            return data
        } catch {
            print("Failed to convert UIColor to NSData: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            print("Failed to cast NSData")
            return nil
        }
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            print("Successfully converted NSData to UIColor")
            return color
        } catch {
            print("Failed to convert NSData to UIColor: \(error)")
            return nil
        }
    }
}
