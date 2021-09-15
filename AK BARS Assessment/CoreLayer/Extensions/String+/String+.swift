//
//  String+.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 30.08.2021.
//

import Foundation

extension String {
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
}
