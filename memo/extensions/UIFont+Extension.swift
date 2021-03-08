import Foundation
import UIKit

extension UIFont {
    @objc class func myFont1() -> UIFont {
        return UIFont.systemFont(ofSize: Scale.share.scaleH(c: 20))
    }
}
