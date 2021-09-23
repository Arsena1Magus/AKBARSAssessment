//
//  AuthorizationModel.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import Foundation

class AuthorizationInteractor {
    var presenter: AuthorizationPresenter?
    private var successModel: AuthorizationSuccessModel?
    
    func getSignin(login: String, password: String) {
        guard let url = URL(string: Constants.ApiServers.authServer) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("3513a0dba72e8fe9af3343a996e7a4ad=39918123a70250efb087bbfac45c1a3d", forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": login,
            "hashedPassword": "fb81ff7afe59de1c8332f66b243cd034cb290fcc196248b65ce3939e7e50c146"
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async {
                    self.presenter?.showAlert("\(String(describing: response)) \(httpStatus.statusCode)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.presenter?.showTestList()
            }
        }
        task.resume()
    }
    
    private func makeHttpBody(parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}
