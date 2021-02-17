//
//  LoginViewController.swift
//  Fitness
//
//  Created by Scott Colas on 1/10/21.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let usernameEmailField: UITextField = {
       let field = UITextField()
        field.placeholder = "UserName..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x:0,y:0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    private let passwordField: UITextField = {
       let field = UITextField()
        field.placeholder = "Password..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x:0,y:0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy", for: .normal)
        return button
    }()
    
    private let creatAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("New User Create account", for: .normal)
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        header.backgroundColor = .red
        let backgroundImageView = UIImageView(image: UIImage(named: "fitnessHeader"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        creatAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        
        
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
        usernameEmailField.delegate = self
        passwordField.delegate = self
        addSubviews()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //assing frames
        headerView.frame = CGRect(
            x: 0,
            y: 0.0,
            width: view.width,
            height: view.height/3.0
        )
       
        
        usernameEmailField.frame = CGRect(
            x:25,
            y:headerView.bottom+40,
            width:  view.width-50,
            height: 52
        )
        
        passwordField.frame = CGRect(
            x:25,
            y:usernameEmailField.bottom+10,
            width:  view.width-50,
            height: 52
        )
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom+10,
            width: view.width-50,
            height: 52
        )
        
        creatAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom+10,
            width: view.width-50,
            height: 52.0
        )
    }
    
    private func configureHeaderView(){
        guard headerView.subviews.count == 1  else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        
        backgroundView.frame = headerView.bounds
        
        
        //Add instagram logo
        let imageView = UIImageView(image: UIImage(named:"text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4, y: view.safeAreaInsets.top, width: headerView.width/2, height: headerView.height-view.safeAreaInsets.top)
    }
    
    
    private func addSubviews(){
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(privacyButton)
        view.addSubview(creatAccountButton)
        view.addSubview(headerView)
    }
    
    @objc func didTapKeyboardDone() {
        usernameEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func didTapSignIn() {
        didTapKeyboardDone()

        guard let email = usernameEmailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {

            let alert = UIAlertController(title: "Woops", message: "Please enter a valid email and password to sign in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        AuthManager.shared.loginUser(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                   // HapticsManager.shared.vibrate(for: .success)
                    self?.dismiss(animated: true, completion: nil)

                case .failure:
                   // HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(
                        title: "Sign In Failed",
                        message: "Please check your email and password to try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    self?.passwordField.text = nil
                }
            }
        }
    }
    @objc private func didTapLoginButton(){
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
        let passowrd = passwordField.text, !passowrd.isEmpty, passowrd.count >= 8 else{
            return
        }
        
        //login functionality
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            email = usernameEmail
        }else{
            username = usernameEmail
        }
        
        AuthManager.shared.loginUserOld(username: username, email: email, password: passowrd) { success in
            // get back on main thread to login
            DispatchQueue.main.async {
                if success{
                    //user logged in
                    self.dismiss(animated: true, completion: nil)
                }else{
                    //error logging in
                    let alert = UIAlertController(title: "Log in Error", message: "We were unable to log you in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
        }
        
    }

 



    @objc private func didTapPrivacyButton(){
        guard let url = URL(string: "www.scottcolas.com") else{
            return
        }
       // let vc = SFSafariViewController(url, url)//
        //present(vc,animated: true)
    }

    @objc private func didTapCreateAccountButton(){
        let vc = RegistrationViewController()
        present(vc ,animated: true)
    }
}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            didTapLoginButton()
        }
        return true
    }
}

