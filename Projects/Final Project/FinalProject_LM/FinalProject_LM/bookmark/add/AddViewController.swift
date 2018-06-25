//
//  AddViewController.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/13/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

protocol AddCrimeDelegate {
    func didFinishAddingCrime(crime: Crime)
}

class AddViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddCrimeDelegate?
    
    var newCrime = Crime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupKeyboardManagement()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let identifier = AddTableViewCell.reuseIdentifier
        let crimeCellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(crimeCellNib, forCellReuseIdentifier: identifier)
    }
    
    fileprivate func setupNavigationBar() {
        let addButton = UIBarButtonItem(title: "Add", style: .plain,
            target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func updateAddButton() {
        navigationItem.rightBarButtonItem?.isEnabled
            = newCrime.areCrimeFilledOut
    }
    
    @objc fileprivate func addButtonPressed() {
        newCrime.bookmarked = true
        let crimeUpdated = CrimeRepository.shared.create(crime: newCrime)
        if crimeUpdated {
            delegate?.didFinishAddingCrime(crime: newCrime)
        }
    }
}

extension AddViewController: AddCellDelegate {
    func didUpdateField(_ text: String, _ addCellType: CrimeRowCellType?) {
        if let addCellType = addCellType {
            newCrime = newCrime.updateCrime(addCellType, text)
            updateAddButton()
        }
    }
}

extension AddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return CrimeRowCellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cellType = CrimeRowCellType(rawValue: indexPath.row)!
        return crimeDetailFor(cellType: cellType, with: indexPath)
    }
}

extension AddViewController {
    fileprivate func configureKeyboardType(_ cellType:
        CrimeRowCellType, _ cell: AddTableViewCell) {
        switch cellType {
        case .policeArea:
            cell.accessoryTextfield.keyboardType = .default
        case .crimeType:
            cell.accessoryTextfield.keyboardType = .default
        case .crimeCode:
            cell.accessoryTextfield.keyboardType = .numberPad
        case .date:
            let datePicker = UIDatePicker()
            datePicker.addTarget(cell, action:
                #selector(cell.hourDatePickerSelected),
                for: .valueChanged)
            datePicker.datePickerMode = .date
            cell.accessoryTextfield.inputView = datePicker
            cell.setDefaultDate()
        case .hour:
            let datePicker = UIDatePicker()
            datePicker.addTarget(cell, action:
                #selector(cell.hourDatePickerSelected),
                for: .valueChanged)
            datePicker.datePickerMode = .time
            cell.accessoryTextfield.inputView = datePicker
            cell.setDefaultDate()
        }
    }
    
    func crimeDetailFor(cellType: CrimeRowCellType, with
        indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = AddTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath)
            as! AddTableViewCell
        
        cell.primaryLabel.text = cellType.title
        cell.addCellType = cellType
        cell.delegate = self
        
        configureKeyboardType(cellType, cell)
        
        if indexPath.row == 0 {
            cell.accessoryTextfield.becomeFirstResponder()
        }
        
        return cell
    }
}

extension AddViewController {
    func setupKeyboardManagement() {
        NotificationCenter.default.addObserver(self, selector: #selector(
            keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(
            keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        let height: CGFloat = (sender.userInfo?[
            UIKeyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue.size.height ?? 0
        
        let duration: TimeInterval = (sender.userInfo?[
            UIKeyboardAnimationDurationUserInfoKey]
            as? NSNumber)?.doubleValue ?? 0
        
        let curveOption: UInt = (sender.userInfo?[
            UIKeyboardAnimationCurveUserInfoKey]
            as? NSNumber)?.uintValue ?? 0
        
        UIView.animate(withDuration: duration, delay: 0, options:
            UIViewAnimationOptions(rawValue: UIViewAnimationOptions
            .beginFromCurrentState.rawValue|curveOption), animations: {
                
            let edgeInsets = UIEdgeInsetsMake(0, 0, height, 0)
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        let duration: TimeInterval = (sender.userInfo?[
            UIKeyboardAnimationDurationUserInfoKey]
            as? NSNumber)?.doubleValue ?? 0
        
        let curveOption: UInt = (sender.userInfo?[
            UIKeyboardAnimationCurveUserInfoKey]
            as? NSNumber)?.uintValue ?? 0
        
        UIView.animate(withDuration: duration, delay: 0, options:
            UIViewAnimationOptions(rawValue: UIViewAnimationOptions
            .beginFromCurrentState.rawValue|curveOption), animations: {
            let edgeInsets = UIEdgeInsets.zero
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        }, completion: nil)
    }
}
