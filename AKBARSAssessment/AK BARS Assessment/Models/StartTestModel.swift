//
//  StartTestModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 13.09.2021.
//

import Foundation

struct StartTestModel {
    var quid: Int = -1
    var cid: Int = -1
    var catid: Int = -1
    var passed: Bool = false
    
    init(json: [String: Any]) {
        if let quid = json["quid"] as? Int {
            self.quid = quid
        }
        if let cid = json["cid"] as? Int {
            self.cid = cid
        }
        if let catid = json["catid"] as? Int {
            self.catid = catid
        }
        if let passed = json["passed"] as? Bool {
            self.passed = passed
        }
    }
}
