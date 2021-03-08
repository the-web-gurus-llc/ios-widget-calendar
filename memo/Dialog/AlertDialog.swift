//
//  AlertDialog.swift
//  memo
//
//  Created by love family on 19.10.2020.
//

import Foundation
import UIKit

class AlertDialog {
    
    static let share = AlertDialog()
    static let WARNING = "警告"
    static let SUCCESS = "成功"
    static let ERROR = "エラー"
    
    private init() {}
    func showAlert(vc: UIViewController, title: String, message: String, handler: ((_ alert: UIAlertAction?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        vc.present(alert, animated: true, completion: nil)
        
    }
}
