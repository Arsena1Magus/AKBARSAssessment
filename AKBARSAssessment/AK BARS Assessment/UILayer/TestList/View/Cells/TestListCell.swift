//
//  TestListCell.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 02.09.2021.
//

import UIKit

class TestListCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .black
        }
    }
    @IBOutlet private var imgView: UIImageView!
    @IBOutlet private var separatorView: UIView!
    
    private var separatorColor: UIColor = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        separatorView.backgroundColor = separatorColor
    }
    
    func setup(_ model: TestListModel) {
        titleLabel.text = model.categoryName
        
        if model.isValid {
            imgView.image = UIImage(named: "success_test")
        } else {
            imgView.image = UIImage(named: "next_test")
        }
    }
    
    func setup(_ model: AnswerModel) {
        titleLabel.text = model.answer1
        
        if model.isValid {
            imgView.image = UIImage(named: "check")
        } else {
            imgView.image = UIImage()
        }
    }
    
    func check(answerChecked: Int) {
        if answerChecked == 1 {
            imgView.image = UIImage(named: "check")
        } else {
            imgView.image = UIImage()
        }
    }
}
