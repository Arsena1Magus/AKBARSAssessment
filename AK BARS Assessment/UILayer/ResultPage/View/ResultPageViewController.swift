//
//  ResultPageViewController.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import UIKit

class ResultPageViewController: UIViewController {
    var parentPresenter: TakingTestPresenter = TakingTestPresenter()
    @IBOutlet private var resultImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .white
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = .white
        }
    }
    @IBOutlet private var onMainButton: UIButton! {
        didSet {
            onMainButton.layer.cornerRadius = 6
            onMainButton.backgroundColor = .white
            onMainButton.setTitle("НА ГЛАВНУЮ", for: .normal)
            onMainButton.tintColor = successColor
        }
    }
    
    @IBAction private func tapOnMainButton() {
        self.dismiss(animated: false, completion: nil)
        parentPresenter.dismiss()
    }
    
    var isSuccessResultPage: Bool = false
    private var successColor: UIColor = UIColor(red: 0.133, green: 0.745, blue: 0.329, alpha: 1)
    private var errorColor: UIColor = UIColor(red: 255/255, green: 71/255, blue: 50/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSuccessResultPage {
            titleLabel.text = "Тест пройден"
            descriptionLabel.text = "Со следующего рабочего дня Вам будет открыта возможность работы с <Раздел>"
            view.backgroundColor = successColor
            resultImage.image = UIImage(named: "success_icon")
        } else {
            titleLabel.text = "Тест не пройден"
            descriptionLabel.text = "К сожалению, Вам не удалось пройти тест по данному разделу! Можете попробовать еще раз, когда будете готовы"
            view.backgroundColor = errorColor
            resultImage.image = UIImage(named: "error_icon")
       }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
