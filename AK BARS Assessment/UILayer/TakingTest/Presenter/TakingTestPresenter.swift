//
//  TakingTestPresenter.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 06.09.2021.
//

import UIKit

class TakingTestPresenter {
    var parentPresenter: TestListPresenter = TestListPresenter()
    var interactor: TakingTestInteractor = TakingTestInteractor()
    var quid: Int = -1
    var tokenModel: TokenModel?
    var cid: Int = -1

    private var questions: [QuestionModel] = []
    private var allResultAnswers: [AnswersResultModel] = []
    private var allAnswers: [[AnswerModel]] = []
    private var allAnswersExecute: [AnswerExecuteModel] = []
    private var parentVC: UIViewController = UIViewController()
    
    func getallResultAnswers(_ answers: [AnswersResultModel]) {
        (parentVC as? TakingTestViewController)?.stopLoader()
        self.allResultAnswers = answers
        
        for index in 0 ..< allResultAnswers.count {
            for executeAnswer in allAnswersExecute {
                if quid == allResultAnswers[index].quid && allResultAnswers[index].qid == executeAnswer.questionId && allResultAnswers[index].aid == executeAnswer.answerId && executeAnswer.answerChecked {
                    allResultAnswers[index].result = true
                }
            }
        }
        
        self.allResultAnswers.sort { $0.result && !$1.result }
        (parentVC as? TakingTestViewController)?.startLoader()
        interactor.updateAnswers(allResultAnswers, quidid: allResultAnswers[0].quidid, quid: quid)
    }
    
    func showResultPage(_ result: Bool, cid: Int) {
        self.cid = cid
        (parentVC as? TakingTestViewController)?.stopLoader()
        let storyBoard: UIStoryboard = UIStoryboard(name: "ResultPageViewController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ResultPageViewController") as! ResultPageViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isSuccessResultPage = result
        vc.parentPresenter = self
        parentVC.present(vc, animated: false, completion: nil)
    }
    
    func showAlert(_ text: String) {
        (parentVC as? TakingTestViewController)?.stopLoader()
        parentVC.showAlert(title: "Что - то пошло не так", msg: text, buttonText: "Понятно", handler: nil)
    }
    
    func setQuestionsAndAnswers(questions: [QuestionModel], allAnswwers: [[AnswerModel]]) {
        (parentVC as? TakingTestViewController)?.stopLoader()
        self.questions = questions
        self.allAnswers = allAnswwers
        self.getAllAnswers()
        (parentVC as? TakingTestViewController)?.setup()
        (parentVC as? TakingTestViewController)?.reload()
    }
    
    func getQuestions(parentVC: UIViewController) {
        interactor.presenter = self
        self.parentVC = parentVC
        if let model = self.tokenModel {
            interactor.getQuestions(quid: quid, tokenModel: model)
        }
    }
    
    func getAllAnswers() {
        for index in 0 ..< questions.count {
            for answer in allAnswers[index] {
                let answerModel = AnswerExecuteModel(questionId: questions[index].qid, answerId: answer.aid, answerChecked: !answer.isValid)
                allAnswersExecute.append(answerModel)
            }
        }
    }
    
    func didSelectRow(_ row: Int, currentStep: Int) {
        if row < allAnswers[currentStep].count {
            if questions[currentStep].bid != 13 {
                for index in 0 ..< allAnswers[currentStep].count {
                    allAnswers[currentStep][index].isValid = false
                }
                allAnswers[currentStep][row].isValid = true
            } else {
                allAnswers[currentStep][row].isValid = allAnswers[currentStep][row].isValid == false ? true : false
            }

            for index in 0 ..< allAnswersExecute.count {
                if questions[currentStep].qid == allAnswersExecute[index].questionId {
                    if questions[currentStep].bid != 13 {
                        if allAnswers[currentStep][row].aid == allAnswersExecute[index].answerId {
                            allAnswersExecute[index].answerChecked = allAnswersExecute[index].answerChecked == false ? true : false
                        } else {
                            allAnswersExecute[index].answerChecked = false
                        }
                    } else {
                        if allAnswers[currentStep][row].aid == allAnswersExecute[index].answerId {
                            allAnswersExecute[index].answerChecked = allAnswersExecute[index].answerChecked == false ? true : false
                        }
                    }
                }
            }
        }
    }
    
    func showResultPage(viewController: UIViewController) -> Bool {
        var allQuestionIds: [Int] = []
        for model in questions {
            allQuestionIds.append(model.qid)
        }
        
        var respondedQuestionIds: [Int] = []
        for model in allAnswersExecute {
            if model.answerChecked {
                respondedQuestionIds.append(model.questionId)
            }
        }
        
        let newRespondedQuestionIds = Array(Set(respondedQuestionIds))
        if newRespondedQuestionIds.count == allQuestionIds.count {
            (parentVC as? TakingTestViewController)?.startLoader()
            interactor.getAnswersByQuestionnaire(quid: quid)
            return true
        }
        return false
    }
    
    func setQuestion(_ currentQuestion: Int) -> String {
        if currentQuestion < questions.count {
            return questions[currentQuestion].question1
        }
        return ""
    }
    
    func getQuestionsCount() -> Int {
        return questions.count
    }
    
    func getAnswerModel(_ row: Int, currentQuestion: Int) -> AnswerModel? {
        if row < allAnswers[currentQuestion].count {
            return allAnswers[currentQuestion][row]
        }
        return nil
    }
    
    func numberOfRowInSection(_ currentQuestion: Int) -> Int {
        return allAnswers[currentQuestion].count
    }
    
    func dismiss() {
        parentVC.dismiss(animated: false, completion: nil)
        parentPresenter.updateTestList(cid: self.cid)
    }
}
