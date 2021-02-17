//
//  BodyPartCollectionViewCell.swift
//  Instagram
//
//  Created by Scott Colas on 1/21/21.
//

import UIKit
protocol BodyPartCollectionViewCellDelegate: AnyObject {
    func didTapGridButtonTab()
    func didTapTaggedButtonTab()
}

class BodyPartCollectionViewCell: UICollectionViewCell {
    static let identifier = "BodyPartCollectionViewCell"
    public weak var delegate: BodyPartCollectionViewCellDelegate?
    private let myImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.masksToBounds = true
        //150 = item size
        imageView.layer.cornerRadius = 48.0/2.0
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        //contenview respects insets around cell
        contentView.addSubview(myImageView)
    }
    
    @objc private func didTapGridButton(){
        
        delegate?.didTapGridButtonTab()
    }
    @objc private func didTapTaggedButton(){
        
        delegate?.didTapTaggedButtonTab()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = contentView.bounds
    }
    
    public func configure(with name: String){
        myImageView.image = UIImage(named: name)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
    }
}
