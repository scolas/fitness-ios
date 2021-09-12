//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Afraz Siddiqui on 12/24/20.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()


        setUpControllers()
    }
/*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }

    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = LoginViewController()
           // vc.completion = { [weak self] in
            //    self?.signInPresented = false
            //}
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false, completion: nil)
        }
    }*/

    private func setUpControllers() {
       /* guard  let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        var urlString: String?
        if let cachedIrlString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cachedIrlString
        }
        let currentUser = User(
            username: username,
            profilePictureURL: URL(string: "" ?? ""),
            identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
        )
        */
        
        /*let currentUser = User(
            username: "username", email: "scolas@gmail.com",
            profilePictureURL: URL(string: "" ?? ""),
            identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
        )*/
        
        let cUser = User(username: "scolas", email: "scolas@gmail.com")
        
        let home = HomeViewController()
        let explore = SearchViewController()
        let camera = CameraViewController()
        let notifications = NotificationViewController()
        let workout = WorkoutViewController()
        let profile = ProfileViewController2(user: cUser)

        notifications.title = "Notifications"
        

        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let cameraNav = UINavigationController(rootViewController: camera)
        let nav3 = UINavigationController(rootViewController: profile)
        let nav4 = UINavigationController(rootViewController: workout)
        

        //nav1.navigationBar.backgroundColor = .clear
        //nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //nav1.navigationBar.shadowImage = UIImage()

        /*cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white*/

        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        cameraNav.navigationBar.tintColor = .label

        //define tab items
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 2)
        cameraNav.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "house"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 4)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)


      

        self.setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
    }

}
