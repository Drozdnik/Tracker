import UIKit

enum OnboardingPageEnum{
    case page1
    case page2
    
    var image:UIImage{
        switch self{
        case .page1:
            return UIImage(named: "Onboarding1")!
        case .page2:
            return UIImage(named: "Onboarding2")!
        }
    }
        
        var message: String{
            switch self{
            case .page1:
                return "Отслеживайте только то, что хотите"
            case .page2:
                return "Даже если это не литры воды и йога"
            }
        }
    }
