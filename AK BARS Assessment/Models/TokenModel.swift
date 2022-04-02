//
//  TokenModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 13.09.2021.
//

import Foundation

struct TokenModel {
    var token: String = ""
    var tokenType: String = ""
    
    init(json: [String: Any]) {
        if let token = json["access_token"] as? String {
            self.token = token
        }
        if let tokenType = json["token_type"] as? String {
            self.tokenType = tokenType
        } else {
            self.tokenType = "Bearer"
        }
    }
}
