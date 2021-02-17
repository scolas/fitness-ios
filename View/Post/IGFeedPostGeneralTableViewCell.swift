//
//  IGFeedPostGeneralTableViewCell.swift
//  Instagram
//
//  Created by Scott Colas on 1/12/21.
//

import UIKit

/// comments
class IGFeedPostGeneralTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostGeneralTableViewCell"
    
    private let postComments: UILabel = {
       let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = .green
        contentView.addSubview(postComments)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: PostComment){
        // configure  the cell
        postComments.text = post.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postComments.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postComments.text = nil
    }

}
