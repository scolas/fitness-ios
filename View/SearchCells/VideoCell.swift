//
//  VideoCell.swift
//  TableView
//
//  Created by Scott Colas on 1/24/21.
//

import UIKit

protocol VideoCellDelegate: AnyObject {
    func videoCell(_ cell:
                    VideoCell,
                   didTapAddWorkoutFor username: String)
}


class VideoCell: UITableViewCell {
    
    var videoImageview = UIImageView()
    //var videoTitlelabel = UILabel()
    static let identifier = "VideoCell"
    
    weak var delegate: VideoCellDelegate?
    
    
    var vids: String?
    
    private let videoTitlelabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    
    private let datelabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
       let button = UIButton()
        button.setTitle("follow1", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(videoImageview)
        
        contentView.addSubview(videoTitlelabel)
        //addSubview(labelTitle)
        contentView.addSubview(followButton)
        contentView.addSubview(datelabel)
        followButton.addTarget(self, action: #selector(didTapAddWorkout), for: .touchUpInside)
        //configureImageView()
        //configureTitleLabel()
        //setImageConstrainst()
        //setTitleConstrainst()
        
      
    }
    
    
    
    @objc func didTapAddWorkout(){
        print("tapped")
        guard let username = vids else {
            return
        }
        
        followButton.setTitle("Added", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.videoCell(self, didTapAddWorkoutFor: username)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView(){
        videoImageview.layer.cornerRadius = 10
        videoImageview.clipsToBounds = true
    }
    
    func configureTitleLabel(){
       // videoTitlelabel.numberOfLines = 0
        //videoTitlelabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func setImageConstrainst(){
        /*videoImageview.translatesAutoresizingMaskIntoConstraints = false
        videoImageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        videoImageview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        videoImageview.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        videoImageview.widthAnchor.constraint(equalTo: videoImageview.heightAnchor, multiplier: 16/9).isActive = true*/
        
        

    }
    
    func setTitleConstrainst(){
       /* videoTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        videoTitlelabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        videoTitlelabel.leadingAnchor.constraint(equalTo: videoImageview.trailingAnchor, constant: 20).isActive = true
        videoTitlelabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1).isActive = true
        videoTitlelabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        */
  

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = 50
        videoImageview.frame = CGRect(
            x: 10,
            y: 3,
            width: iconSize,
            height: iconSize
        )
        
        
        videoImageview.layer.cornerRadius = 25
        videoImageview.layer.masksToBounds = true
        
       
        
        followButton.sizeToFit()
        followButton.frame = CGRect(
            x: contentView.width - followButton.width - 70,
            y: 10,
            width: 100,
            height: 30
        )
        
        videoTitlelabel.sizeToFit()
        datelabel.sizeToFit()
        
        
        let labelSize = videoTitlelabel.sizeThatFits(
            CGSize(
                width: contentView.width - 30 - followButton.width - iconSize,
                height: contentView.height - 40
            )
        )
        
        videoTitlelabel.frame = CGRect(
            x: videoImageview.right + 10,
            y: 0,
            width: 105,
            height: 40
        )
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoImageview.image = nil
        videoTitlelabel.text = nil
        datelabel.text = nil
        followButton.setTitle("Follow5", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
    }
    
    func set(video: Search){
        videoImageview.image = video.image
        videoTitlelabel.text = video.username
        //labelTitle.text = video.username
    }
    func configure(with username: String, model: Search){
        videoImageview.image = UIImage(named: "test")
        videoTitlelabel.text = model.name
        self.vids = username
       // datelabel.text = .date(with: model.username)
        
    }
}
