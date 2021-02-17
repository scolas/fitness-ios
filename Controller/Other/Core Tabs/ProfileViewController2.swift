//
//  ProfileViewController.swift
//  Fitness
//
//  Created by Scott Colas on 1/16/21.
//

import UIKit
import SDWebImage
class ProfileViewController2: UIViewController {
    private var collectionView:UICollectionView?
    
    private var userPosts = [UserPost]()
    var filterBody = BodyPart.legs
    var user: User
    
    // MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        
        userPosts = fetchData(ca: filterBody)
        configureNavigationBar()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        //padding between layouts
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        //part 8 3:27
        let size = (view.width-4)/3
        // part 5 21:20
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.backgroundColor = .systemBackground
        //register all cells
        //Cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        //Headers
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
       
        
        //Tabs
        collectionView?.register(ProfileTabCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileTabCollectionReusableView.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionview = collectionView else{
            return
        }
        view.addSubview(collectionview)
    }



    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //frame entirety of screen
        collectionView?.frame = view.bounds
    }
    private func configureNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettingsButton))
    }
    @objc private func didTapSettingsButton(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ProfileViewController2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return userPosts.count
        //return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model =  userPosts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        //cell.backgroundColor = .systemBlue
        
        cell.configure(with: model)
        //cell.configure(debug: "test")
        return cell
    }
    
    
    // this is called when user click the cell or post
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // get the model and open post controller
        //let model = userPosts[indexPath.row]
        let vc = PostViewController(model: userPosts[indexPath.row])
        vc.title = "Workout"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            //footer
            return UICollectionReusableView()
        }
        
        if indexPath.section == 1{
            //tabs header
            let tabsControlHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: ProfileTabCollectionReusableView.identifier,
                                                                                for: indexPath) as! ProfileTabCollectionReusableView
            tabsControlHeader.delegate = self
            return tabsControlHeader
        }
        
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier,
                                                                            for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // height of header in profile tab
        if section == 0 {
            return CGSize(width: collectionView.width,
                          height: collectionView.height/4)
        }
        
        // Size of section tabs
        
        return CGSize(width: collectionView.width,
                      height: 50)
    }
    

}



extension ProfileViewController2: ProfileTabCollectionReusableViewDelegate{
    
    func didTapGridButtonTab() {
        //
        userPosts = fetchData(ca: BodyPart.legs)
        collectionView?.reloadData()
        print("cardio tapped")
    }
    
    func didTapTaggedButtonTab() {
        //
        userPosts = fetchData(ca: BodyPart.chest)
        collectionView?.reloadData()
        print("cardio tapped")
    }
    
    func didTapCardioButtonTab() {
        //
        userPosts = fetchData(ca: BodyPart.abs)
        collectionView?.reloadData()
        print("cardio tapped")
    }
    
    func didTapWeightButtonTab() {
        
        userPosts = fetchData(ca: BodyPart.other)
        collectionView?.reloadData()
        print("weight tapped")
    }
    
    
}

extension ProfileViewController2: ProfileInfoHeaderCollectionReusableViewDelegate{
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        // scroll to the posts section
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData = [UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(username: "@scolas", name: "Scott Colas", type: x % 2 == 0 ? .following : .not_following))
        }
        let vc = ListViewController(data: mockData)
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData = [UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(username: "@scolas", name: "Scott Colas", type: x % 2 == 0 ? .following : .not_following))
        }
        let vc = ListViewController(data: mockData)
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditPorfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        present(UINavigationController(rootViewController: vc), animated: true)
        
    }
    
    func profileHeaderDidTapWorkoutButton(_ header: ProfileInfoHeaderCollectionReusableView){
        let vc = WorkoutViewController()
        vc.title = "Create Workout"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
}

extension ProfileViewController2 {
    func fetchData(ca: BodyPart) -> [UserPost]{
        let comment1 = PostComment(identifier: "",
                                  username: "@scott",
                                  text: "I like",
                                  createdDate: Date(),
                                  likes: [])
        let comment2 = PostComment(identifier: "",
                                  username: "@sbentley",
                                  text: "I like",
                                  createdDate: Date(),
                                  likes: [])
        let comment3 = PostComment(identifier: "",
                                  username: "@ferrari",
                                  text: "I like",
                                  createdDate: Date(),
                                  likes: [])
        
        /*let user = User(username: "scott",
                        bio: "",
                        name: (first: "", last: ""),
                        profilePhoto: URL(string: "https://www.google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 102, following: 99, posts: 5),
                        joinDate: Date())*/
        let user = User(
            username: UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me",
            profilePictureURL: URL(string: ""),
            identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? "")
        
        let posts = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://i.pinimg.com/originals/79/f0/14/79f014a31c85b20aca132e959ba149c6.jpg")!, thumbnailImage: URL(string: "https://i.pinimg.com/originals/79/f0/14/79f014a31c85b20aca132e959ba149c6.jpg")!, caption: nil, likecount: [], comments:[comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.abs, owner: user)
        
        let posts2 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://media.self.com/photos/58a34c9c37f75e231dae7240/master/w_1600%2Cc_limit/Screen%2520Shot%25202017-02-14%2520at%25201.29.24%2520PM.png")!, thumbnailImage: URL(string: "https://media.self.com/photos/58a34c9c37f75e231dae7240/master/w_1600%2Cc_limit/Screen%2520Shot%25202017-02-14%2520at%25201.29.24%2520PM.png")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.arms, owner: user)

        let posts3 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://media.self.com/photos/58a358c19d6f39ff71b333af/master/w_1600%2Cc_limit/Screen%2520Shot%25202017-02-14%2520at%25202.21.21%2520PM.png")!, thumbnailImage: URL(string: "https://media.self.com/photos/58a358c19d6f39ff71b333af/master/w_1600%2Cc_limit/Screen%2520Shot%25202017-02-14%2520at%25202.21.21%2520PM.png")!, caption: nil, likecount: [], comments:[comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.chest, owner: user)
        
        let posts4 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://i2.wp.com/qui2health.com/wp-content/uploads/2020/02/75554010_178559103288651_8254203824522381638_n.jpg?fit=1080%2C1242&ssl=1")!, thumbnailImage: URL(string: "https://i2.wp.com/qui2health.com/wp-content/uploads/2020/02/75554010_178559103288651_8254203824522381638_n.jpg?fit=1080%2C1242&ssl=1")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        
        let posts5 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://i.dailymail.co.uk/i/pix/2018/02/14/01/49300C4F00000578-5388607-Roping_em_in_Kevin_Hart_is_set_to_expose_his_audience_to_all_new-a-17_1518571339202.jpg")!, thumbnailImage: URL(string: "https://i.dailymail.co.uk/i/pix/2018/02/14/01/49300C4F00000578-5388607-Roping_em_in_Kevin_Hart_is_set_to_expose_his_audience_to_all_new-a-17_1518571339202.jpg")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        let posts6 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://www.muscleandfitness.com/wp-content/uploads/2020/05/Fitness-Professional-Doing-Behind-The-Back-Lateral-Raise.jpg?w=1109&quality=86&strip=all")!, thumbnailImage: URL(string: "https://www.muscleandfitness.com/wp-content/uploads/2020/05/Fitness-Professional-Doing-Behind-The-Back-Lateral-Raise.jpg?w=1109&quality=86&strip=all")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        let posts7 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://www.trainmag.com/wp-content/uploads/2017/09/christian-guzman-post.jpg")!, thumbnailImage: URL(string: "https://www.trainmag.com/wp-content/uploads/2017/09/christian-guzman-post.jpg")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        
        let posts8 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://funkshion.miami/wp-content/uploads/2018/04/ron-boss.jpg")!, thumbnailImage: URL(string: "https://funkshion.miami/wp-content/uploads/2018/04/ron-boss.jpg")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        let posts9 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://manofmany.com/wp-content/uploads/2020/11/Lebron-James-Workout.jpg")!, thumbnailImage: URL(string: "https://manofmany.com/wp-content/uploads/2020/11/Lebron-James-Workout.jpg")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        let posts10 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://cdn.shopify.com/s/files/1/0482/4380/2272/products/hero-4.jpg?v=1601670033")!, thumbnailImage: URL(string: "https://cdn.shopify.com/s/files/1/0482/4380/2272/products/hero-4.jpg?v=1601670033")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        let posts11 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://i2.wp.com/qui2health.com/wp-content/uploads/2019/01/walk.gif?fit=440%2C440&ssl=1")!, thumbnailImage: URL(string: "https://i2.wp.com/qui2health.com/wp-content/uploads/2019/01/walk.gif?fit=440%2C440&ssl=1")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        let posts12 = UserPost(identifier: "", postType: .photo, postUrl: URL(string: "https://images.milledcdn.com/2019-05-12/eDLpxxDtA0jaTXWg/K94JrcGkTjb1.jpg")!, thumbnailImage: URL(string: "https://images.milledcdn.com/2019-05-12/eDLpxxDtA0jaTXWg/K94JrcGkTjb1.jpg")!, caption: nil, likecount: [], comments: [comment1,comment2], createdDate: Date(), taggedUsers: [], category: BodyPart.legs, owner: user)
        
        if(ca == BodyPart.legs){
            return [posts4,posts5]
        }
        if(ca == BodyPart.chest){
            return [posts,posts7]
        }
        if(ca == BodyPart.abs){
            return [posts2,posts7]
        }
        return [posts,posts2, posts3, posts4, posts5,posts12, posts6, posts7, posts8,posts9,posts10,posts11]
    }
}
