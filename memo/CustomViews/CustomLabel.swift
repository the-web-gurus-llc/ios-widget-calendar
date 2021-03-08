//
//  CustomLabel.swift
//  memo
//
//  Created by love family on 28.10.2020.
//

import Foundation
import UIKit


class CustomLabel: UILabel {

    override func draw(_ rect: CGRect)
    {
        
        let π = Double.pi

        
        let diameter = (min(frame.width, frame.height))
        let radius = diameter / 2.0 - 4
        
        let centrePoint = CGPoint(x: frame.width/2.0, y: frame.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        UIColor.calendarBackColor.setFill()
        ringPath.fill()
    }

}
