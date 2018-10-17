//
//  HomeViewController.swift
//  TOCTest
//
//  Created by Karim on 14/10/2018.
//  Copyright © 2018 Karim. All rights reserved.
//


import UIKit

import CollectionViewSlantedLayout
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!

    let reuseIdentifier = "customViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout.isFirstCellExcluded = true
        collectionViewLayout.isLastCellExcluded = true
    }

    
    // ViewWillAppear -> reloadData
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
}

// MARK: CollectionView Datasource

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataAccess.shared.events.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                            as? CustomCollectionCell else {
            fatalError()
        }

        // Download an display image
        
        if let value = DataAccess.shared.events[indexPath.row]["image"] as? PFFile {
            value.getDataInBackground(block: {
                (data: Data?, error: Error?) in
                
                if error == nil {
                    let image = UIImage(data: data!)
                    if image != nil {
                        cell.imageView.image = image
                    }
                }
            })
        }
        
        // Convert date
        
        if let date = (DataAccess.shared.events[indexPath.row]["startDate"] as? Date){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let newDate = dateFormatter.string(from: date)
            cell.dateLabel.text = newDate
        }
        
        cell.nameLabel.text = DataAccess.shared.events[indexPath.row]["name"] as? String
        cell.cityLabel.text = DataAccess.shared.events[indexPath.row]["city"] as? String
        cell.locationNameLabel.text = DataAccess.shared.events[indexPath.row]["locationName"] as? String
        
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        }

        return cell
    }
}


// MARK: CollectionView Delegate

extension HomeViewController: CollectionViewDelegateSlantedLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Did select item at indexPath: [\(indexPath.section)][\(indexPath.row)]")
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: CollectionViewSlantedLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [CustomCollectionCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = (collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight
            let xOffset = (collectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth
            parallaxCell.offset(CGPoint(x: xOffset * xOffsetSpeed, y: yOffset * yOffsetSpeed))
        }
    }
}
