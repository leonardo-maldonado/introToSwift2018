//
//  CrimeDetailTableViewCell.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/11/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class CrimeDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var primaryLabel: UILabel! {
        didSet {
            primaryLabel.textColor = .lightGray
        }
    }
    
    static let reuseIdentifier = "CrimeDetailTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
