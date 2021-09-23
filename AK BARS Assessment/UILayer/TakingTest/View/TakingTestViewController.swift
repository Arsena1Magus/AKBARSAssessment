//
//  TakingTestViewController.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 06.09.2021.
//

import UIKit

class TakingTestViewController: UIViewController {
    var presenter: TakingTestPresenter = TakingTestPresenter()
    var testName: String = ""
    
    @IBOutlet private var navTitleLabel: UILabel! {
        didSet {
            navTitleLabel.textColor = .black
        }
    }
    @IBOutlet private var navImage: UIImageView!
    @IBOutlet private var navSeparatorView: UIView! {
        didSet {
            navSeparatorView.backgroundColor = separatorColor
        }
    }
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var stepLabel: UILabel! {
        didSet {
            stepLabel.textColor = lightGrayText
        }
    }
    @IBOutlet private var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("ДАЛЕЕ", for: .normal)
            nextButton.tintColor = UIColor(red: 0.133, green: 0.745, blue: 0.329, alpha: 1)
        }
    }
    @IBOutlet private var backButton: UIButton! {
        didSet {
            backButton.setTitle("НАЗАД", for: .normal)
            backButton.tintColor = lightGrayText
        }
    }
    @IBOutlet private var questionLabel: UILabel! {
        didSet {
            questionLabel.textColor = .black
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = lightGrayText
        }
    }
    @IBOutlet private var loader: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction private func tapNavButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction private func tapBackButton() {
        currentStep = currentStep == 1 ? currentStep : currentStep - 1
        if progressStep == 100 {
            progressStep = progressStep - 1 - step
        }
        progressStep = progressStep == step ? progressStep : progressStep < step ? step : progressStep - step
        progressView.setProgress(progressStep / 100, animated: true)
        setStep(currentStep)
        
        questionLabel.text = presenter.setQuestion(currentStep - 1)
        tableView.reloadData()
    }
    
    @IBAction private func tapNextButton() {
        if currentStep == presenter.getQuestionsCount() {
            if !presenter.showResultPage(viewController: self) {
                self.showAlert(title: "Ответьте пожалуйста на все вопросы!", msg: "", buttonText: "Понятно", handler: nil)
            }
        } else {
            currentStep += 1
            if currentStep == presenter.getQuestionsCount() {
                progressStep = 100
            } else {
                progressStep = progressStep == step * Float(presenter.getQuestionsCount()) ? progressStep : progressStep + step
            }
            progressView.setProgress(progressStep / 100, animated: true)
            setStep(currentStep)
            
            questionLabel.text = presenter.setQuestion(currentStep - 1)
            tableView.reloadData()
        }
    }
    
    private var step: Float = 11
    private var progressStep: Float = 11
    private var currentStep: Int = 1
    private var lightGrayText: UIColor = UIColor(red: 0.706, green: 0.706, blue: 0.706, alpha: 1)
    private var progressColor: UIColor = UIColor(red: 0.133, green: 0.745, blue: 0.329, alpha: 1)
    private var separatorColor: UIColor = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.isHidden = true
        navSeparatorView.isHidden = true
        progressView.isHidden = true
        backButton.isHidden = true
        nextButton.isHidden = true
        
        startLoader()
        presenter.getQuestions(parentVC: self)
    }
    
    func setup() {
        tableView.isHidden = false
        navSeparatorView.isHidden = false
        progressView.isHidden = false
        backButton.isHidden = false
        nextButton.isHidden = false
        
        step = 100 / Float(presenter.getQuestionsCount())
        progressStep = step
        progressView.progressTintColor = progressColor
        progressView.trackTintColor = separatorColor
        progressView.setProgress(progressStep / 100, animated: false)
        
        navTitleLabel.text = testName
        descriptionLabel.text = "Выберите один или несколько вариантов ответа"
        questionLabel.text = presenter.setQuestion(currentStep - 1)
        navImage.image = UIImage(named: "close_black")
        setupTableView()
        setStep(currentStep)
    }
    
    func stopLoader() {
        loader.stopAnimating()
    }
    
    func startLoader() {
        loader.startAnimating()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    private func setStep(_ currentStep: Int) {
        stepLabel.text = "шаг \(currentStep) из \(presenter.getQuestionsCount())"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: String(describing: TestListCell.self), bundle: nil), forCellReuseIdentifier: TestListCell.reuseIdentifier)
    }
}

extension TakingTestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowInSection(currentStep - 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TestListCell.reuseIdentifier) as? TestListCell {
            if let model = presenter.getAnswerModel(indexPath.row, currentQuestion: currentStep - 1) {
                cell.setup(model)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(indexPath.row, currentStep: currentStep - 1)
        tableView.reloadData()
    }
}
