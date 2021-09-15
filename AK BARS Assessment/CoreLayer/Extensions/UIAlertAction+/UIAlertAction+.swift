//
//  UIAlertAction+.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 01.09.2021.
//

import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
