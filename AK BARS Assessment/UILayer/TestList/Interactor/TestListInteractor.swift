//
//  TestListModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 13.09.2021.
//

import Foundation

class TestListInteractor {
    var presenter: TestListPresenter?
    private var tokenModel: TokenModel?
    private var authorizationSuccessModel: AuthorizationSuccessModel?
    private var testList: [TestListModel] = []
    private var newTestList: [StartTestModel] = []
    
    func startTest(catid: Int) {
        guard let model = self.tokenModel, let authorizationModel = self.authorizationSuccessModel, let url = URL(string: Constants.ApiServers.mainServer + "Questionnaires/PostQuestionnaire") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "cid": authorizationModel.cid,
            "catid": catid
        ]
        request.httpBody = makeHttpBody(parameters: parameters)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.presenter?.showTakingTest(StartTestModel(json: json))
                    }
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    func getToken(login: String) {
        guard let url = URL(string: Constants.ApiServers.tokenServer) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "client_id": "xhDXowkusxgW8BrZAN9GZtRngVOX7GER",
            "client_secret": "-8yzlTSL2UoDdmNgLv0nCIF-YCEG1JSAPSpwB0jRR5_IDxl0ZHmzWGs1iPMW4C4l",
            "audience": "https://qualification.akbf.ru",
            "grant_type": "client_credentials"
        ]
        request.httpBody = makeHttpBody(parameters: parameters)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.tokenModel = TokenModel(json: json)
                    if let model = self.tokenModel {
                        self.presenter?.setTokenModel(model)
                    }
                    self.getClientByLogin(login)
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    private func getClientByLogin(_ login: String) {
        guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "Clients/GetClientByLogin/\(login)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.authorizationSuccessModel = AuthorizationSuccessModel(json: json)
                    self.getCategories()
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    private func getCategories() {
        guard let model = self.tokenModel, let authModel = self.authorizationSuccessModel, let url = URL(string: Constants.ApiServers.mainServer + "Categories") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    self.testList = json.compactMap { TestListModel(json: $0) }
                    self.getQuestionnaireByCid(cid: authModel.cid)
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    private func getQuestionnaireByCid(cid: Int) {
        guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "Questionnaires/GetQuestionnaireByCid/\(cid)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    self.newTestList = json.compactMap { StartTestModel(json: $0) }
                    for i in 0..<self.testList.count {
                        self.testList[i].isValid = false
                    }
                    for model in self.newTestList {
                        for i in 0..<self.testList.count {
                            if self.testList[i].catid == model.catid {
                                if model.passed {
                                    self.testList[i].isValid = model.passed
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.presenter?.setTests(tests: self.testList)
                    }
                }
            } catch {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
        }
        task.resume()
    }
    
    
    func updateTestList(cid: Int) {
        guard let model = self.tokenModel, let url = URL(string: Constants.ApiServers.mainServer + "Questionnaires/GetQuestionnaireByCid/\(cid)") else { return }
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue(model.tokenType + " " + model.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("Попробуйте позже")
                }
                return
            }
                
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    self.newTestList = json.compactMap { StartTestModel(json: $0) }
                    DispatchQueue.main.async {
                        self.presenter?.startUpdateTestList(self.newTestList)
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
