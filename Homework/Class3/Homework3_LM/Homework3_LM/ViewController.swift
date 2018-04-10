//
//  ViewController.swift
//  Homework3_LM
//
//  Created by Leonardo Maldonado on 4/8/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    let messageFromAnimationStart: CGFloat = -60.0
    let messageFromAnimationEnd: CGFloat = 10.0
    let bottomStackAnimationStart: CGFloat = -40.0
    let bottomStackAnimationEnd: CGFloat = 10.0
    let iphoneXHomeIndicatorSize: CGFloat = -24
    
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet var messageButtons: [UIButton]!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var messageFromBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackBottomConstraint: NSLayoutConstraint!
    
    var messages = [Message]()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.loadMessages()
        self.configureButtons()
        self.setAnimationInitialState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animate()
    }
    
    // MARK: IBAction
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        let index = sender.tag - 1
        let message = self.messages[index]
        self.fromNameLabel.text = message.fromName
        self.bodyLabel.text = message.body
        self.stateLabel.text = "State: \(message.state.txt)"
    }
    
    // MARK: Helper Methods
    
    private func configureNavigationBar() {
        self.title = "Messages"
        let refreshBarButtonItem = UIBarButtonItem(title: "Refresh",
            style:UIBarButtonItemStyle.plain, target: self, action:
            #selector(refreshButtonPressed))
        refreshBarButtonItem.tintColor = UIColor.darkGray
        self.navigationItem.leftBarButtonItem = refreshBarButtonItem
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style:
            UIBarButtonItemStyle.plain, target: self, action:
            #selector(editButtonPressed))
        editBarButtonItem.tintColor = UIColor.darkGray
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func refreshButtonPressed() {
        // refresh logic
    }
    
    @objc private func editButtonPressed() {
        // edit logic
    }
    
    private func loadMessages() {
        self.messages = Message.defaultData
    }
    
    private func configureButtons() {
        for button in self.messageButtons {
            let index = button.tag - 1
            let message = messages[index]
            button.setTitle(message.fromName, for: .normal)
            button.backgroundColor = UIColor.black
            button.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    fileprivate func setAnimationInitialState() {
        self.bottomStackBottomConstraint.constant
            = self.bottomStackAnimationStart
            + self.iphoneXHomeIndicatorSize
        self.messageFromBottomConstraint.constant
            = self.messageFromAnimationStart
            + self.iphoneXHomeIndicatorSize
        self.view.layoutIfNeeded()
    }
    
    fileprivate func animate() {
        self.bottomStackBottomConstraint.constant
            = self.bottomStackAnimationEnd
        self.messageFromBottomConstraint.constant
            = messageFromAnimationEnd
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

