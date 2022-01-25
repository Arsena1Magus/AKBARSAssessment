//
//  AuthorizationSuccessModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 31.08.2021.
//

import Foundation

struct AuthorizationSuccessModel {
    var cid: Int = -1
    var clientCode: String = ""
    var userName: String = ""
    
    init(json: [String: Any]) {
        if let cid = json["cid"] as? Int {
            self.cid = cid
        }
        if let clientCode = json["clientCode"] as? String {
            self.clientCode = clientCode
        }
        if let userName = json["userName"] as? String {
            self.userName = userName
        }
    }
}
