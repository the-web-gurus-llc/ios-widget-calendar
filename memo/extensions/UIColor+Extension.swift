//
//  UIColor+Extension.swift
//  memo
//
//  Created by love family on 19.10.2020.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static let mainColor: UIColor = UIColor(named: "MainColor") ?? .black
    static let selColor: UIColor = UIColor(named: "SelColor") ?? .black
    static let calendarBackColor: UIColor = UIColor(named: "CalendarBack") ?? .black
    static let wColor: UIColor = UIColor(named: "WSColor") ?? .black
    static let calendarLColor: UIColor = UIColor(named: "CalendarLColor") ?? .black
    static let selectionBackground: UIColor = UIColor(named: "SelectionBackground") ?? .black
}