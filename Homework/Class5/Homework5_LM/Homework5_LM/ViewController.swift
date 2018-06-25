//
//  ViewController.swift
//  Homework5_LM
//
//  Created by Leonardo Maldonado on 4/15/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

enum ColorType: Int {
    case red
    case blue
    case random
}

class ViewController: UIViewController {

    var colorViewModels = [ColorViewModel]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet {
            segmentControl.addTarget(self, action: #selector(
                segmentControlValueChanged), for: .valueChanged)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Color Table"
        self.colorViewModels = ColorManager.generateColors(
            desired: 100, with: .red)
        self.tableView.reloadData()
    }
    
    @objc private func segmentControlValueChanged() {
        let segmentIndex = self.segmentControl.selectedSegmentIndex
        let colorType = ColorType(rawValue: segmentIndex)!
        self.colorViewModels = ColorManager.generateColors(
            desired: 100, with: colorType)
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var item = self.colorViewModels[indexPath.row]
        item.isSelected = !item.isSelected
        self.colorViewModels[indexPath.row] = item
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return self.colorViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let item = self.colorViewModels[indexPath.row]
        let cell = UITableViewCell()
        cell.backgroundColor = item.color
        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = UIColor.white
        cell.accessoryType = item.isSelected ? .checkmark : .none
        return cell
    }
}
