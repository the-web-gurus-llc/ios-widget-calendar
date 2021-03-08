//
//  CustomOctagonal.swift
//  memo
//
//  Created by love family on 28.10.2020.
//

import Foundation
import UIKit

enum CustomOctagonalType {
    case Left
    case LeftRight
    case Right
}

class CustomOctagonal: UIView {
    
    var fillColor: UIColor = .mainColor
    var type: CustomOctagonalType = .Left
    
    override func draw(_ rect: CGRect)
    {
        let padding = Scale.share.percentH(c: HomeUIConf.octagonalPadding)
//        let width = Scale.share.percentH(c: HomeUIConf.bottomBtnWidth)
//        let height = Scale.share.percentH(c: HomeUIConf.bottomHeight)
        let width = frame.width
        let height = frame.height
        
        let path = UIBezierPath()
        switch type {
        case .Right:
            path.move(to: CGPoint(x: 0, y: 0))
        default:
            path.move(to: CGPoint(x: 0, y: padding))
        }
        path.addLine(to: CGPoint(x: padding, y: 0))
        switch type {
        case .Left:
            path.addLine(to: CGPoint(x: width, y: 0))
        default:
            path.addLine(to: CGPoint(x: width - padding, y: 0))
        }
        path.addLine(to: CGPoint(x: width, y: padding))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        fillColor.setFill()
        path.fill()
    }

}
