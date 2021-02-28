//
//  PostViewController.swift
//  Instagram
//
//  Created by Scott Colas on 1/5/21.
//
enum PostRenderType {
    //case header(provider: User)
    //case primarycontent(provider: UserPost) // post
    case primarycontent(provider: PostModel)
    case actions(provider: String) //like cmment share
    case comments(comments: [PostComment])
}

/// Model of rendered Post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

import UIKit

class PostViewController: UIViewController {
    private let model: PostModel
    
    private var renderModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register Cells
        tableView.register(IGFeedPostTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels(){
        //guard let userPostModel = self.model else {
          //  return
        //}
      
        
        //Header
       // renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        //Post
        renderModels.append(PostRenderViewModel(renderType: .primarycontent(provider: model)))
        //Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        //comments
        var comments = [PostComment]()
        comments.append(PostComment(identifier: "",
                                    username: "@scolas",
                                    text: "3 Sets Planks 1 min each",
                                    createdDate: Date(),
                                    likes: []))
                        
        comments.append(PostComment(identifier: "",
                                    username: "@Lambo",
                                    text: "10 Sets of push ups till failure",
                                    createdDate: Date(),
                                    likes: []))
                        
        comments.append(PostComment(identifier: "",
                                    username: "@King",
                                    text: "5 Sets of Dips",
                                    createdDate: Date(),
                                    likes: []))
        
        comments.append(PostComment(identifier: "123",
                                    username: "@Kendrick",
                                    text: "Bench Press 3 Sets",
                                    createdDate: Date(),
                                    likes: []))
        for x in 0..<4 {
            comments.append(PostComment(identifier: "123_\(x)",
                                        username: "@Kendrick",
                                        text: "Bench Press 3 Sets\(x)",
                                        createdDate: Date(),
                                        likes: []))
        }
         renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground

       
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

  
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
            case .actions(_): return 1
            case .comments(let comments): return comments.count > 4 ? 4 : comments.count
            case .primarycontent(_): return 1
            //case .header(_): return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType {
            case .actions(let actions):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                return cell
                
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                cell.configure(with: comments[indexPath.row])
                return cell
                
            case .primarycontent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(with: post)
                return cell
                
           // case .header(let users):
             //   let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                //return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
            case .actions(_):
                return 60
            case .comments(_):
                return 50
            case .primarycontent(_):
                return tableView.width
            //case .header(_):
              //  return 70
        }
    }
    
}
