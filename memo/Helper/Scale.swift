import Foundation
import UIKit

class Scale {
    static let share = Scale()
    private init() {}

    private let originalHeight: CGFloat = 896
    private let originalWidth: CGFloat = 414
    
    func scaleV(c: CGFloat) -> CGFloat {
        return c * UIScreen.main.bounds.height / originalHeight
    }
    
    func scaleH(c: CGFloat) -> CGFloat {
        return c * UIScreen.main.bounds.width / originalWidth
    }
    
    func percentV(c: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.height * CGFloat(c)
    }
    
    func percentH(c: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * CGFloat(c)
    }
}
