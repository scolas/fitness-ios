//
//  NotificationViewController.swift
//  Fitness
//
//  Created by Scott Colas on 2/12/21.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userMe = User(username: "", email: "")
    
    private let noNotificationsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.isHidden = true
        label.textAlignment = .center
        
        return label
    }()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.isHidden = true
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell")
        
        table.register(
            NotificationsPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier
        )
        
        table.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier
        )
        
        table.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier
        )
        
        return table
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noNotificationsLabel)
        view.addSubview(spinner)
        view.backgroundColor = .brown
        tableView.delegate = self
        tableView.dataSource = self
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
        fetchNotifications()
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl){
        sender.beginRefreshing()
        //+3 delay allows us to see spinner
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    

    func fetchNotifications(){
        DatabaseManager.shared.getNotifications{ [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    func updateUI(){
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        }else{
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    //Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type{
        
        
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationsPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: postName, model: model)
            cell.delegate = self
            return cell
            
            
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationsUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: username, model: model)
            cell.delegate = self
            return cell
            
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationsPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: postName, model: model)
            cell.delegate = self
            return cell
        }
        
      
    }
    
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       
            return .delete
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard  editingStyle == .delete else {
            return
        }
        let model = notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    //filter out hidden notifications
                    self?.notifications = self?.notifications.filter({ $0.isHidden == false}) ?? []
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                    //tableView.reloadData()
                }
            }
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
 

extension NotificationViewController: NotificationsUserFollowTableViewCellDelegate{
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.follow(username: username) { (success) in
            if !success {
                print("follow failed")
            }
        }
        
        
        
    }


    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController2(user: userMe)
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension NotificationViewController: NotificationsPostLikeTableViewCellDelegate {
    func notificationsPostLikeTableViewCell(_ cell: NotificationsPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}


extension NotificationViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell, didTapPost identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationViewController{
    func openPost(with identifier: String){
        //reslove postmodel from database
        let post = PostModel(
            identifier: UUID().uuidString,
            user: userMe,
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.abs,
             owner: userMe
        )
        let vc = PostViewController(model: post)
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
