//
//  GalleryCollectionViewCell.swift
//  Expense Tracker
//
//  Created by Nisal Padukka on 2022-08-06.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageUrl:URL? = nil
    
    public func configure(with image:UIImage, imagePath:URL){
        imageView.image = image
        imageUrl = imagePath
    }
    
}
