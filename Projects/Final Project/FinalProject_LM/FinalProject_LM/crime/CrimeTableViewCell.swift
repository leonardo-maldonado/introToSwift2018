//
//  CrimeTableViewCell.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/11/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class CrimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel! {
        didSet {
            typeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.textColor = .darkGray
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet {
            dateLabel.textColor = UIColor.lightGray
        }
    }
    
    static let reuseIdentifier = "CrimeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
