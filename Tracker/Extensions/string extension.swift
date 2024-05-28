import Foundation
extension String {
    static func getNoun(number: Int, one: String, two: String, five: String) -> String {
        let n = abs(number) % 100
        if n >= 5 && n <= 20 {
            return five
        }
        switch n % 10 {
        case 1:
            return one
        case 2...4:
            return two
        default:
            return five
        }
    }
}
