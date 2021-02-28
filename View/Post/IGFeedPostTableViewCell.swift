//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by Scott Colas on 1/12/21.
//
import AVFoundation
import SDWebImage
import UIKit

final class IGFeedPostTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // public func configure(with post: UserPost){
    public func configure(with post: PostModel){
        // configure  the cell
        
        //postImageView.image = UIImage(named: "test")
        //return
        // configure  the cell
        switch post.postType{
        case .photo:
            //show photo
            //postImageView.sd_setImage(with: post.postUrl, completed: nil)
            postImageView.sd_setImage(with: URL(string: post.fileName), completed: nil)
        
        case .video:
            let urlFile = post.fileName
            guard let url = URL(string: urlFile) else{
                return
            }
            //show video
           
            //player = AVPlayer(url: post.postUrl)
            player = AVPlayer(url: url)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
            
        }
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
}
