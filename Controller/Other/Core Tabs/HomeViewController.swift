//
//  ViewController.swift
//  Fitness
//
//  Created by Scott Colas on 1/7/21.
//
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOme"
        view.backgroundColor = .red
        //handleNotAuthenticated()
        configure()
        
    }
   /* override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //check auth status
        
    }*/
    
    private func handleNotAuthenticated(){
        if Auth.auth().currentUser == nil{
            let loginVc = LoginViewController()
            loginVc.modalPresentationStyle = .fullScreen
            present(loginVc, animated: false)
        }

    }
    
    private func configure(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
    }
    
    @objc private func didTapSettings(){
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc),animated: true)
    }

}

