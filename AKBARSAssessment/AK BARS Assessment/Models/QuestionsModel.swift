//
//  AnswersModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 06.09.2021.
//

import Foundation

struct AnswerModel {
    var aid: Int = -1
    var qid: Int = -1
    var answer1: String = ""
    var isValid: Bool = false
    
    init(json: [String: Any]) {
        if let aid = json["aid"] as? Int {
            self.aid = aid
        }
        if let qid = json["qid"] as? Int {
            self.qid = qid
        }
        if let answer1 = json["answer1"] as? String {
            self.answer1 = answer1
        }
        if let isValid = json["isValid"] as? Bool {
            self.isValid = isValid
        }
    }
}

struct QuestionModel {
    var qid: Int = -1
    var catid: Int = -1
    var bid: Int = -1
    var question1: String = ""
    var evaluation: Int = -1
    var isValid: Bool = false
    var minAnswers: Int = -1
    
    init(json: [String: Any]) {
        if let qid = json["qid"] as? Int {
            self.qid = qid
        }
        if let bid = json["bid"] as? Int {
            self.bid = bid
        }
        if let question1 = json["question1"] as? String {
            self.question1 = question1
        }
        if let catid = json["catid"] as? Int {
            self.catid = catid
        }
        if let evaluation = json["evaluation"] as? Int {
            self.evaluation = evaluation
        }
        if let isValid = json["isValid"] as? Bool {
            self.isValid = isValid
        }
        if let minAnswers = json["minAnswers"] as? Int {
            self.minAnswers = minAnswers
        }
    }
}
