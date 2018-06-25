//
//  AddTableViewCell.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/13/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

protocol AddCellDelegate {
    func didUpdateField(_ text: String, _ addCellType: CrimeRowCellType?)
}

class AddTableViewCell: UITableViewCell {

    @IBOutlet weak var primaryLabel: UILabel! {
        didSet {
            primaryLabel.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var accessoryTextfield: UITextField! {
        didSet {
            accessoryTextfield.delegate = self
            accessoryTextfield.addDoneButtonOnKeyboard()
        }
    }
    
    static let reuseIdentifier = "AddTableViewCell"
    
    var delegate: AddCellDelegate?
    
    var addCellType: CrimeRowCellType? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension AddTableViewCell {
    
    func setDefaultDate() {
        let formattedDate = formatDate(with: Date())
        accessoryTextfield.text = formattedDate
        delegate?.didUpdateField(formattedDate, addCellType)
    }
    
    func formatDate(with date: Date) -> String {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        
        let datePicker = accessoryTextfield.inputView
            as! UIDatePicker
        
        if datePicker.datePickerMode == .date {
            dateFormatter.dateFormat = "MM/dd/yyyy"
        } else {
            dateFormatter.timeStyle = .short
        }
        
        // Apply date format
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    @objc func hourDatePickerSelected(_ sender: UIDatePicker) {
        let formattedDate = formatDate(with: sender.date)
        accessoryTextfield.text = formattedDate
        delegate?.didUpdateField(formattedDate, addCellType)
    }
}

extension AddTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:
        NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text else { return true }
        
        let expectedText = (currentText as NSString).replacingCharacters(
            in: range, with: string)
        
        delegate?.didUpdateField(expectedText, addCellType)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
