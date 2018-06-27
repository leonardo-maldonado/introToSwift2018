//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 7/1/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CrimeViewController: UIViewController {
    
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var crimes: [Crime]?
    
    let midPosition: CGFloat = UIScreen.main.bounds.midY
    
    let topPosition: CGFloat = UIScreen.main.bounds.minY + 88
    
    var bottomPosition: CGFloat {
        return UIScreen.main.bounds.height -
            (tabBarController?.tabBar.frame.size.height)! - 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crimes"
        setupTableView()
        
        let gesture = UIPanGestureRecognizer.init(
            target: self, action: #selector(CrimeViewController.panGesture))
        view.addGestureRecognizer(gesture)
        
        roundViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        prepareBackgroundView()
        getCrimes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.midPosition
            self?.view.frame = CGRect(x: 0, y: yComponent!, width:
                frame!.width, height: frame!.height)
        })
    }
    
    fileprivate func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addRefreshControl()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        let crimeCellIdentifier = CrimeTableViewCell.reuseIdentifier
        let crimeCellNib = UINib(nibName:
            crimeCellIdentifier, bundle: nil)
        
        let crimeHeaderCellIdentifier
            = CrimeHeaderTableViewCell.reuseIdentifier
        let crimeHeaderCellNib = UINib(nibName:
            crimeHeaderCellIdentifier, bundle: nil)
        
        tableView.register(crimeCellNib,
            forCellReuseIdentifier: crimeCellIdentifier)
        
        tableView.register(crimeHeaderCellNib,
            forHeaderFooterViewReuseIdentifier:
            crimeHeaderCellIdentifier)
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        if y + translation.y >= topPosition && y + translation.y <= bottomPosition {
            
            self.view.frame = CGRect(x: 0, y: y + translation.y, width:
                view.frame.width, height: view.frame.height)
            
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options:
                [.allowUserInteraction], animations: {
                    
                    let swipeDown = velocity.y > 0
                    let swipeUp = velocity.y < 0
                    
                    let viewIsOnTop = self.view.frame.minY <= self.midPosition
                    let viewIsOnBottom = self.view.frame.minY >= self.midPosition
                    
                    if swipeDown && viewIsOnBottom {
                        
                        self.view.frame = CGRect( x: 0, y: self.bottomPosition, width:
                            self.view.frame.width, height: self.view.frame.height)
                        
                    } else if swipeUp && viewIsOnBottom {
                        
                        self.view.frame = CGRect(x: 0, y: self.midPosition, width:
                            self.view.frame.width, height: self.view.frame.height)
                        
                    } else if swipeDown && viewIsOnTop {
                        
                        self.view.frame = CGRect(x: 0, y: self.midPosition, width:
                            self.view.frame.width, height: self.view.frame.height)
                        
                    } else if swipeUp && viewIsOnTop {
                        
                        self.view.frame = CGRect(x: 0, y: self.topPosition, width:
                            self.view.frame.width, height: self.view.frame.height)
                    }
                    
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 8
        holdView.layer.cornerRadius = 3
        view.clipsToBounds = true
    }
    
    func prepareBackgroundView() {
        view.backgroundColor = .white
        holdView.backgroundColor = .lightGray
    }
    
    fileprivate func addRefreshControl() {
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action:
            #selector(refreshCrimeData), for: .valueChanged)
    }
    
    @objc fileprivate func refreshCrimeData() {
        refreshControl.endRefreshing()
        CrimeRepository.shared.getAllRemote { (crimes, error) in
            guard let crimes = crimes
                else { return }
            self.crimes = crimes
            self.tableView.reloadData()
        }
    }
    
    fileprivate func getCrimes() {
        CrimeRepository.shared.getAll { (crimes, error) in
            guard let crimes = crimes
                else { return }
            self.crimes = crimes
            self.tableView.reloadData()
        }
    }
}

extension CrimeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let crimeDetailStoryboard = UIStoryboard.init(
            name: "CrimeDetailViewController", bundle: nil)
        let crimeDetailViewController = crimeDetailStoryboard
            .instantiateInitialViewController()
            as! CrimeDetailViewController
        crimeDetailViewController.delegate = self
        crimeDetailViewController.crime = crimes![indexPath.row]
        
        navigationController?.pushViewController(
            crimeDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection
        section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection
        section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection
        section: Int) -> UIView? {
        
        let reuseIdentifier = CrimeHeaderTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        cell?.backgroundView = backgroundView
        
        return cell
    }
}

extension CrimeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        guard let crimes = self.crimes else { return 0 }
        return crimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        guard let crimes = self.crimes
            else { return UITableViewCell() }
        
        let identifier = CrimeTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath)
            as! CrimeTableViewCell
        
        cell.typeLabel?.text = crimes[indexPath.row].crimeType
        cell.descLabel?.text = "\(crimes[indexPath.row].crimeType). " +
            "Disclaimer: This is from the Puerto Rico Open Data Portal. " +
        "Information subject to change."
        cell.dateLabel?.text = crimes[indexPath.row].date.formatted
        
        return cell
    }
}

extension CrimeViewController: CrimeDetailDelegate {
    func didFinish() {
        getCrimes()
    }
}


