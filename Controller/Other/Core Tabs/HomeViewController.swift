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
        view.backgroundColor = .systemBackground
        handleNotAuthenticated()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //check auth status
        
    }
    
    private func handleNotAuthenticated(){
        if Auth.auth().currentUser == nil{
            let loginVc = LoginViewController()
            loginVc.modalPresentationStyle = .fullScreen
            present(loginVc, animated: false)
        }

    }

}

