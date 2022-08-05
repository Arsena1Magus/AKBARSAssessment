//
//  TestListPresenter.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import UIKit

class TestListPresenter {
    var interactor: TestListInteractor = TestListInteractor()
    
    private var parentVC: UIViewController = UIViewController()
    private var tests: [TestListModel] = []
    private var selectedTest: TestListModel?
    private var startTestModel: StartTestModel?
    private var tokenModel: TokenModel?
    var login: String = ""
    
    func showAlert(_ text: String) {
        (parentVC as? TestListViewController)?.stopLoader()
        parentVC.showAlert(title: "Что - то пошло не так", msg: text, buttonText: "Понятно", handler: { [weak self] _ in
            self?.parentVC.navigationController?.popViewController(animated: true)
        })
    }
    
    func didSelectRow(_ row: Int) {
        if row < tests.count {
            if !tests[row].isValid {
                selectedTest = tests[row]
                if let test = selectedTest {
                    (parentVC as? TestListViewController)?.startLoader()
                    interactor.startTest(catid: test.catid)
                }
            } else {
                parentVC.showAlert(title: "", msg: "Тест пройден", buttonText: "Понятно", handler: nil)
            }
        }
    }
    
    func showTakingTest(_ model: StartTestModel) {
        (parentVC as? TestListViewController)?.stopLoader()
        self.startTestModel = model
        if let test = selectedTest, let model = tokenModel, let quid = self.startTestModel?.quid {
            let storyBoard: UIStoryboard = UIStoryboard(name: "TakingTestViewController", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TakingTestViewController") as! TakingTestViewController
            vc.testName = test.categoryName
            vc.presenter.tokenModel = model
            vc.presenter.parentPresenter = self
            vc.presenter.quid = quid
            vc.modalPresentationStyle = .fullScreen
            parentVC.present(vc, animated: false, completion: nil)
        }
    }
    
    func getTestModel(_ row: Int) -> TestListModel? {
        if row < tests.count {
            return tests[row]
        }
        return nil
    }
    
    func numberOfRowInSection() -> Int {
        return tests.count
    }
    
    func getToken(parentVC: UIViewController) {
        self.parentVC = parentVC
        interactor.presenter = self
        interactor.getToken(login: login)
    }
    
    func setTests(tests: [TestListModel]) {
        self.tests = tests
        (parentVC as? TestListViewController)?.reload()
        (parentVC as? TestListViewController)?.stopLoader()
    }
    
    func setTokenModel(_ model: TokenModel) {
        self.tokenModel = model
    }
    
    func updateTestList(cid: Int) {
        (parentVC as? TestListViewController)?.startLoader()
        interactor.updateTestList(cid: cid)
    }
    
    func startUpdateTestList(_ newTestList: [StartTestModel]) {
        (parentVC as? TestListViewController)?.stopLoader()
        for model in newTestList {
            if model.quid == startTestModel?.quid {
                for index in 0 ..< tests.count {
                    if tests[index].catid == startTestModel?.catid {
                        tests[index].isValid = model.passed
                        break
                    }
                }
            }
        }
        (parentVC as? TestListViewController)?.reload()
    }
}
