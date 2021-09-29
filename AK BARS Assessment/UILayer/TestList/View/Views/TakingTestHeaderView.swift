//
//  TakingTestHeaderView.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 29.09.2021.
//

import UIKit

class TakingTestHeaderView: UITableViewHeaderFooterView {
    private var lightGrayText: UIColor = UIColor(red: 0.706, green: 0.706, blue: 0.706, alpha: 1)
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
       super.awakeFromNib()
        
        contentView.backgroundColor = .white
        descriptionLabel.textColor = lightGrayText
        questionLabel.textColor = .black
    }
}
