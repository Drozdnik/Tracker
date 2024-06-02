//
//  UIColorExtension.swift
//  Tracker
//
//  Created by Михаил  on 10.04.2024.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(format: "#%02lX%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)),
                      lroundf(Float(a * 255)))
    }
    
    func isEqualToColor(_ otherColor: UIColor, withTolerance tolerance: CGFloat = 0.001) -> Bool {
           var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
           var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

           self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
           otherColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

           return abs(r1 - r2) <= tolerance && abs(g1 - g2) <= tolerance && abs(b1 - b2) <= tolerance && abs(a1 - a2) <= tolerance
       }
   }

