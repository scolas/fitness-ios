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
    }

    private func setUpControllers() {
       // let home = ProfileViewController2()
        let explore = SearchViewController()
        let camera = CameraViewController()
        let notifications = NotificationViewController()
        let workout = WorkoutViewController()
        
        var urlString: String?
        if let cachedIrlString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cachedIrlString
        }

         let profile = ProfileViewController2(
            user: User(
                username: UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me",
                profilePictureURL: URL(string: urlString ?? ""),
                identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""))

        notifications.title = "Notifications"
        

        let nav1 = UINavigationController(rootViewController: profile)
        let nav2 = UINavigationController(rootViewController: explore)
        let cameraNav = UINavigationController(rootViewController: camera)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: workout)
        

        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()

        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white

        nav3.navigationBar.tintColor = .label

        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)

        if #available(iOS 14.0, *) {
            nav1.navigationItem.backButtonDisplayMode = .minimal
            nav2.navigationItem.backButtonDisplayMode = .minimal
            nav3.navigationItem.backButtonDisplayMode = .minimal
            nav4.navigationItem.backButtonDisplayMode = .minimal
            cameraNav.navigationItem.backButtonDisplayMode = .minimal
        }

        nav4.navigationBar.tintColor = .label

        setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
    }

}
