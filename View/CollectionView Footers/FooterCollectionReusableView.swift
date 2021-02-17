//
//  FooterCollectionReusableView.swift
//  Fitness
//
//  Created by Scott Colas on 1/17/21.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
    static let identifier = "FooterCollectionReusableView"
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "Footer text"
        
        return label
    }()
    
    public func configure(){
        backgroundColor = .green
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
