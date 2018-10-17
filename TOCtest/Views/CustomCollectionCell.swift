//
//  CustomCollectionCell.swift
//  TOCTest
//
//  Created by Karim on 14/10/2018.
//  Copyright © 2018 Karim. All rights reserved.
//

import Foundation

import UIKit

import CollectionViewSlantedLayout

// Param for parallax scrolling

let yOffsetSpeed: CGFloat = 150.0
let xOffsetSpeed: CGFloat = 100.0

class CustomCollectionCell: CollectionViewSlantedCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var gradient = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Design cell
        
        if let backgroundView = backgroundView {
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.frame = backgroundView.bounds
            backgroundView.layer.addSublayer(gradient)
            dateLabel.transform = CGAffineTransform(rotationAngle:75.38)
            cityLabel.transform = CGAffineTransform(rotationAngle:75.38)
            locationNameLabel.transform = CGAffineTransform(rotationAngle:75.38)
            nameLabel.transform = CGAffineTransform(rotationAngle:75.38)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let backgroundView = backgroundView {
            gradient.frame = backgroundView.bounds
        }
    }

    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    var imageHeight: CGFloat {
        return 750
    }

    var imageWidth: CGFloat {
        return 750
    }

    func offset(_ offset: CGPoint) {
        imageView.frame = imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}
