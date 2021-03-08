import Foundation
import UIKit

class CustomOval: UIButton {

    override func draw(_ rect: CGRect)
    {
//        let x = Scale.share.percentH(c: 0.03)
//        let y = (Scale.share.percentV(c: HomeUIConf.bottomHeight) - Scale.share.percentH(c: 0.1)) / 2
//        let width = Scale.share.percentH(c: 0.19)
//        let height = Scale.share.percentH(c: 0.1)
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        UIColor.calendarBackColor.setFill()
        ovalPath.fill()
    }

}
