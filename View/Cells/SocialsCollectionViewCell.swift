//
//  SocialsCollectionViewCell.swift
//  Fitness
//
//  Created by Scott Colas on 1/17/21.
//

import UIKit

class SocialsCollectionViewCell: UICollectionViewCell {

    
    static let identifier = "SocialsCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SocialsCollectionViewCell", bundle: nil)
    }
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }
 
}
