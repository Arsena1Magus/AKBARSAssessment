//
//  TakingTestInteractor.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 13.09.2021.
//

import Foundation

class TakingTestInteractor {
    var presenter: TakingTestPresenter?
    
    private var tokenModel: TokenModel?
    private var questions: [QuestionModel] = []
    private var allAnswwers: [[AnswerModel]] = []
    private var allResultAnswers: [AnswersResultModel] = []
    
    var countIterations: Int = 0
    
    func getQuestions(quid: Int, tokenModel: TokenModel) {
        self.tokenModel = tokenModel
        guard let url = URL(string: Constants.ApiServers.mainServer + "Questions/GetQuestionnaireQuestions/\(quid)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(tokenModel.tokenType + " " + tokenModel.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert(String(describing: error))
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("\(String(describing: response)) \(httpStatus.statusCode)")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    self.questions = json.compactMap { QuestionModel(json: $0)}
                    for question in self.questions {
                        self.getAnswers(quid: question.qid)
                    }
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    func getAnswers(quid: Int) {
        guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "Answers/GetQuestionAnswers/\(quid)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert(String(describing: error))
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("\(String(describing: response)) \(httpStatus.statusCode)")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let answers: [AnswerModel] = json.compactMap { AnswerModel(json: $0) }
                    self.allAnswwers.append(answers)
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            if self.questions.count == self.allAnswwers.count {
                DispatchQueue.main.async {
                    self.presenter?.setQuestionsAndAnswers(questions: self.questions, allAnswwers: self.allAnswwers)
                }
            }
        }
        task.resume()
    }
    
    func getAnswersByQuestionnaire(quid: Int) {
        guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "QuestionnaireDetails/GetAnswersByQuestionnaire/\(quid)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert(String(describing: error))
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("\(String(describing: response)) \(httpStatus.statusCode)")
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    self.allResultAnswers = json.compactMap { AnswersResultModel(json: $0)}
                    DispatchQueue.main.async {
                        self.presenter?.getallResultAnswers(self.allResultAnswers)
                    }
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    func updateAnswers(_ answers: [AnswersResultModel], quidid: Int, quid: Int) {
        if !answers.isEmpty {
            guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "QuestionnaireDetails/SendQuestionnaireAnswer/\(quidid)") else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
            request.httpMethod = "PUT"
            let parameters: [String: Any] = [
                "quidid": quidid,
                "quid": answers[countIterations].quid,
                "qid": answers[countIterations].qid,
                "aid": answers[countIterations].aid,
                "result": answers[countIterations].result
            ]
            request.httpBody = makeHttpBody(parameters: parameters)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {                                                 
                    print("error=\(String(describing: error))")
                    DispatchQueue.main.async {
                        self.presenter?.showAlert(String(describing: error))
                    }
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 204 {           
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    DispatchQueue.main.async {
                        self.presenter?.showAlert("\(String(describing: response)) \(httpStatus.statusCode)")
                    }
                    return
                }
                
                self.countIterations += 1
                if answers.count == self.countIterations {
                    DispatchQueue.main.async {
                        self.getResult(quid: quid)
                        self.countIterations = 0
                    }
                } else {
                    self.updateAnswers(answers, quidid: quidid, quid: quid)
                }
            }
            task.resume()
        }
    }
    
    private func getResult(quid: Int) {
        guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "Questionnaires/GetQuestionnaireScore/\(quid)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert(String(describing: error))
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("\(String(describing: response)) \(httpStatus.statusCode)")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let resultModel = StartTestModel(json: json)
                    DispatchQueue.main.async {
                        self.presenter?.showResultPage(resultModel.passed, cid: resultModel.cid)
                    }
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    private func makeHttpBody(parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}
