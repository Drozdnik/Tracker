import Foundation
extension String {
    static func getLocalizedNounForNumber(_ number: Int) -> String {
            let one = NSLocalizedString("day_one", comment: "For singular")
            let few = NSLocalizedString("day_few", comment: "For few")
            let many = NSLocalizedString("day_many", comment: "For many or zero")

            let n = abs(number) % 100
            let n1 = n % 10
            
            if Locale.current.languageCode == "en" {
                return number == 1 ? one : many
            } else {
                if n1 == 1 && n != 11 {
                    return one
                } else if n1 >= 2 && n1 <= 4 && !(n >= 12 && n <= 14) {
                    return few
                } else {
                    return many
                }
            }
        }
    }
