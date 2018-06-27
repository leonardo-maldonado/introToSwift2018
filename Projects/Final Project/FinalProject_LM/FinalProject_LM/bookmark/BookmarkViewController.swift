//
//  BookmarkViewController.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/13/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var crimes: [Crime]?
    var bookmarkDataStore = BookmarkDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCrimes()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.isEditing = editing
    }
    
    fileprivate func getCrimes() {
        bookmarkDataStore.getAll { (crimes, error) in
            self.crimes = crimes
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let crimeCellIdentifier = CrimeTableViewCell.reuseIdentifier
        let crimeCellNib = UINib(nibName:
            crimeCellIdentifier, bundle: nil)
        
        tableView.register(crimeCellNib,
            forCellReuseIdentifier: crimeCellIdentifier)
    }
    
    fileprivate func setupNavigationBar() {
        title = "Bookmarks"
        let buttomItem = UIBarButtonItem(barButtonSystemItem: .add, target:
            self, action: #selector(addCrimePressed))
        navigationItem.rightBarButtonItem = buttomItem
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @objc fileprivate func addCrimePressed() {
        let storyboard = UIStoryboard.init(
            name: "AddViewController", bundle: nil)
        let addController = storyboard
            .instantiateInitialViewController()
            as! AddViewController
        addController.delegate = self
        navigationController?.pushViewController(
            addController, animated: true)
    }
}

extension BookmarkViewController: AddCrimeDelegate {
    func didFinishAddingCrime(crime: Crime) {
        crimes?.append(crime)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension BookmarkViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let index = indexPath.row
            let crimeToDelete = crimes![index]
            crimes!.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
            _ = bookmarkDataStore.delete(crime: crimeToDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath:
        IndexPath) -> UITableViewCellEditingStyle {
        
        guard let crimes = crimes, !crimes.isEmpty else {
            return .none
        }
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath:
        IndexPath, to destinationIndexPath: IndexPath) {
        guard var crimes = crimes else { return }
        let movedObject = crimes[sourceIndexPath.row]
        crimes.remove(at: sourceIndexPath.row)
        crimes.insert(movedObject, at: destinationIndexPath.row)
        _ = bookmarkDataStore.updateAll(crimes: crimes)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:
        IndexPath) -> CGFloat {
        
        guard let crimes = crimes, !crimes.isEmpty else {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let navigationBar = navigationController?.navigationBar
            guard let navigationBarHeight = navigationBar?.bounds.height
                else { return CGFloat.leastNormalMagnitude }
            guard let tabBarHeight = tabBarController?.tabBar.bounds
                .height else { return CGFloat.leastNormalMagnitude }
            let offset = navigationBarHeight + tabBarHeight + statusBarHeight
            return view.bounds.height - offset
        }
        
        return UITableViewAutomaticDimension
    }
}

extension BookmarkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        guard let count = crimes?.count else {
            return 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        guard let crimes = crimes, !crimes.isEmpty else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            tableView.separatorStyle = .none
            navigationItem.leftBarButtonItem?.isEnabled = false
            cell.textLabel?.text
                = "You don't have any bookmarks yet."
            return cell
        }
        
        let identifier = CrimeTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath)
            as! CrimeTableViewCell
        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        navigationItem.leftBarButtonItem?.isEnabled = true
        
        cell.typeLabel?.text = crimes[indexPath.row].crimeType
        cell.descLabel?.text = "\(crimes[indexPath.row].crimeType). " +
            "Disclaimer: This is from the " +
            "Puerto Rico Open Data Portal. Information subject to change."
        cell.dateLabel?.text = crimes[indexPath.row].date
        
        return cell
    }
}
