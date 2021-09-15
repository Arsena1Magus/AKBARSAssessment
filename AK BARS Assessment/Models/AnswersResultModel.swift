//
//  AnswersResultModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 14.09.2021.
//

import Foundation

struct AnswersResultModel {
    var quidid: Int = -1
    var quid: Int = -1
    var qid: Int = -1
    var aid: Int = -1
    var result: Bool = false
    
    init(json: [String: Any]) {
        if let quidid = json["quidid"] as? Int {
            self.quidid = quidid
        }
        if let quid = json["quid"] as? Int {
            self.quid = quid
        }
        if let qid = json["qid"] as? Int {
            self.qid = qid
        }
        if let aid = json["aid"] as? Int {
            self.aid = aid
        }
        if let result = json["result"] as? Bool {
            self.result = result
        }
    }
}
