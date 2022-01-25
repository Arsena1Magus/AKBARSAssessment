//
//  UIView+.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import UIKit

extension UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
