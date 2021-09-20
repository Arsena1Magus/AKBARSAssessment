//
//  AnswerExecuteModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 07.09.2021.
//

import Foundation

struct AnswerExecuteModel {
    var questionId: Int = -1
    var answerId: Int = -1
    var answerChecked: Bool = false
    
    init(questionId: Int, answerId: Int, answerChecked: Bool) {
        self.questionId = questionId
        self.answerId = answerId
        self.answerChecked = answerChecked
    }
}
