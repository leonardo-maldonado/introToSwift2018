//
//  CrimeDetailViewController.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/11/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import MapKit

enum CrimeRowCellType: Int {
    case policeArea
    case crimeType
    case crimeCode
    case date
    case hour
    
    var title: String {
        switch self {
        case .policeArea:
            return "Police Area"
        case .crimeType:
            return "Crime Type"
        case .crimeCode:
            return "Crime Code"
        case .date:
            return "Date"
        case .hour:
            return "Hour"
        }
    }
    
    static var count: Int {
        return CrimeRowCellType.hour.rawValue + 1
    }
}

protocol CrimeDetailDelegate {
    func didFinish()
}

class CrimeDetailViewController: UIViewController {

    @IBOutlet weak var mapSnapshotImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var crime: Crime!
    var delegate: CrimeDetailDelegate!
    var bookmarkDataSource = BookmarkDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        getMapSnapshoot()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let defaultIdentifier = CrimeDetailTableViewCell.reuseIdentifier
        let defaultNib = UINib(nibName: defaultIdentifier, bundle: nil)

        tableView.register(defaultNib, forCellReuseIdentifier:
            defaultIdentifier)
    }
    
    fileprivate func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let deselectedBookmark = UIImage(named:
            "baseline_bookmark_border_black_24pt")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: deselectedBookmark , style: .plain, target:
            self, action: #selector(bookmarkIconPressed))
        updateNavigationIcon()
    }
    
    fileprivate func toogleBookmarkStatus() {
        guard let bookmarked = crime.bookmarked else {
            crime.bookmarked = true
            return
        }
        crime.bookmarked = !bookmarked
    }
    
    @objc fileprivate func bookmarkIconPressed() {
        toogleBookmarkStatus()
        
        guard let bookmarked = crime.bookmarked
            else { return }

        if bookmarked {
            addCrimeToBookmarks()
        } else {
            deleteCrimeFromBookmarks()
        }
    }
    
    fileprivate func addCrimeToBookmarks() {
        let crimeUpdated = CrimeRepository
            .shared.update(crime: crime)
        
        let bookmarkSaved = bookmarkDataSource
            .update(crime: crime)
        
        if crimeUpdated && bookmarkSaved {
            updateNavigationIcon()
            delegate.didFinish()
        }
    }
    
    fileprivate func deleteCrimeFromBookmarks() {
        let crimeUpdated = CrimeRepository
            .shared.update(crime: crime)
        
        let bookmarkDeleted = bookmarkDataSource
            .delete(crime: crime)
        
        if bookmarkDeleted && crimeUpdated {
            updateNavigationIcon()
            delegate.didFinish()
        }
    }
    
    fileprivate func updateNavigationIcon() {
        let selectedBookmark = UIImage(
            named: "baseline_bookmark_black_24pt")
        let deselectedBookmark = UIImage(named:
            "baseline_bookmark_border_black_24pt")
        guard let bookmarked = crime.bookmarked else { return }
        navigationItem.rightBarButtonItem?.image =
            bookmarked ? selectedBookmark : deselectedBookmark
    }
}

extension CrimeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection
        section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CrimeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return CrimeRowCellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let identifier = CrimeDetailTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath)
            as! CrimeDetailTableViewCell
        
        let cellType = CrimeRowCellType(
            rawValue: indexPath.row)
        cell.primaryLabel.text = cellType?.title
        
        switch cellType {
        case .policeArea?:
            cell.accessoryLabel.text = crime?.policeArea
        case .crimeType?:
            cell.accessoryLabel.text = crime?.crimeType
        case .crimeCode?:
            cell.accessoryLabel.text = crime?.crimeCode
        case .date?:
            cell.accessoryLabel.text = crime?.date.formatted
        case .hour?:
            cell.accessoryLabel.text = crime?.hour
        case .none:
            return UITableViewCell()
        }
        
        return cell
    }
}

extension CrimeDetailViewController {
    fileprivate func getMapSnapshoot() {
        let mapSnapshotOptions = MKMapSnapshotOptions()
        
        /// Set the region of the map that is rendered.
        guard let latitude = crime.location?.coordinates[1] else { return }
        guard let longitude = crime.location?.coordinates[0] else { return }
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMakeWithDistance(location, 500, 500)
        mapSnapshotOptions.region = region
        
        /// Set the scale of the image. We'll just use the scale of
        /// the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        /// Set the size of the image output.
        mapSnapshotOptions.size = CGSize(
            width: UIScreen.main.bounds.height, height: 300)
        
        /// Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start { (snapshot:MKMapSnapshot?, error: Error?) in
            let image = snapshot?.image
            DispatchQueue.main.async {
                self.mapSnapshotImage.image = image
            }
        }
    }
}
