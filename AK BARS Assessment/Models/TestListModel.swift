//
//  TestListModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import Foundation

struct TestListModel {
    var catid: Int = -1
    var categoryName: String = ""
    var isValid: Bool = false
    
    init(json: [String: Any]) {
        if let catid = json["catid"] as? Int {
            self.catid = catid
        }
        if let categoryName = json["categoryName"] as? String {
            self.categoryName = categoryName
        }
        if let isValid = json["isValid"] as? Bool {
            self.isValid = isValid
        }
    }
    
    init(catid: Int, categoryName: String, isValid: Bool) {
        self.catid = catid
        self.categoryName = categoryName
        self.isValid = isValid
    }
}
