//
//  UITextField+DoneButton.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/24/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//
import UIKit

extension UITextField {
    
    var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let frame = CGRect.init(x: 0, y: 0, width:
            UIScreen.main.bounds.width, height: 50)
        let doneToolbar: UIToolbar = UIToolbar(frame: frame)
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem:
            .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done", style: .done, target: self,
            action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
