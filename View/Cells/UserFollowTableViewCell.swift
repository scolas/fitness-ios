//
//  UserFollowTableViewCell.swift
//  Instagram
//
//  Created by Scott Colas on 1/19/21.
//

import UIKit
protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationship)
}
enum FollowState{
    case following //indecate the current user is following the other user
    case not_following // indicates the current use is not following the other user
}
struct UserRelationship{
    let username: String
    let name: String
    let type: FollowState
}
class UserFollowTableViewCell: UITableViewCell {
    static let identifier = "UserFollowTableViewCell"
    // weak so we dont cause memory leak with two strong references
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private var model: UserRelationship?
    
    private let profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.masksToBounds  = true
        imageview.backgroundColor = .secondarySystemBackground
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let namelabel: UILabel = {
        let label = UILabel()
        label.contentMode = .scaleAspectFill
        label.text = "Scotty"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let usernamelabel: UILabel = {
        let label = UILabel()
        label.contentMode = .scaleAspectFill
        label.text = "Scolas"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(namelabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernamelabel)
        contentView.addSubview(followButton)
        selectionStyle = .none
        followButton.addTarget(self,
                               action: #selector(didTapFollowButton),
                               for: .touchUpInside)
    }
    
    @objc private func didTapFollowButton(){
        guard let model = model else {
            return
        }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with model: UserRelationship){
        self.model = model
        namelabel.text = model.name
        usernamelabel.text = model.username
        switch model.type {
        case .following:
            //show unfollow button
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .not_following:
            // show follow button
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        namelabel.text = nil
        usernamelabel.text = nil
        followButton.setTitle(nil, for: .normal)
        // for unfollow state
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height-6,
                                        height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2.0
        // fix size for ipad
        let buttonWidth = contentView.width > 500 ? 220 : contentView.width/3
        followButton.frame = CGRect(x: contentView.width-5-buttonWidth,
                                    y: (contentView.height-40)/2,
                                    width: buttonWidth,
                                    height: 40)
        let labelheight = contentView.height/2
        namelabel.frame = CGRect(x: profileImageView.right+5,
                                 y: 0,
                                 width: contentView.width-8-profileImageView.width-buttonWidth,
                                 height: labelheight)
        usernamelabel.frame = CGRect(x: profileImageView.right+5,
                                     y: namelabel.bottom,
                                     width: contentView.width-8-profileImageView.width-buttonWidth,
                                     height: labelheight)
    }
}
