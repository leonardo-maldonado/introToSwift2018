//
//  CrimeHeaderTableViewCell.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/11/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class CrimeHeaderTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.image = UIImage(named: "crime_icon")
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Crime"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.text = "RECENTLY REPORTED CRIMES IN PUERTO RICO"
            descLabel.font = UIFont.systemFont(ofSize: 12)
            descLabel.textColor = .darkGray
        }
    }
    
    static let reuseIdentifier = "CrimeHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }
}
