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
        return UIColor.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}
