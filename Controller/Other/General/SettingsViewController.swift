//
//  SettingsViewController.swift
//  Fitness
//
//  Created by Scott Colas on 1/16/21.
//

import SafariServices
import UIKit

struct SettingCellModel{
    let title: String
    let handler: (() -> Void)
}

/// View controller to show user settings
class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    //called after all other subview have layed out
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    private func configureModels(){
        
        
        
        data.append( [
            SettingCellModel(title: "Edit Profile") { [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite Friends") { [weak self] in
                self?.didTapInvteFriends()
            },
            SettingCellModel(title: "Save Original Posts") { [weak self] in
                self?.didTapSaveOriginalPost()
            }
        ])
        
        data.append( [
            SettingCellModel(title: "Terms of Service") { [weak self] in
                self?.openUrl(type: .terms)
            },
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.openUrl(type: .privacy)
            },
            SettingCellModel(title: "Help & Feedback") { [weak self] in
                self?.openUrl(type: .help)
            }
        ])
        
        
      
        
        //log out section
        data.append( [
            SettingCellModel(title: "Log out") { [weak self] in
                self?.didTapLogOut()
            }
        ])
    }

    
    enum SettingsURLType{
        case terms,privacy,help
    }
    
    private func didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        //if we leave this out edit profile presentation will be swipe down able
        navVC.modalPresentationStyle = . fullScreen
        present(navVC, animated: true)
    }
    
    
    private func didTapInvteFriends(){
        //show share sheet to invite friends
        
    }
    
    
    private func didTapSaveOriginalPost(){
        
    }
    private func openUrl(type: SettingsURLType){
        let urlString: String
        switch type {
        case .terms: urlString=""
        case .help: urlString=""
        case .privacy: urlString=""
        }
        
        guard let url=URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
   
    
    
    private func didTapLogOut(){
        let actionSheet = UIAlertController(title: "Log out",
                                            message: "Are you sure you want to log out",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: {_ in
                                                
            //show action sheet
            AuthManager.shared.logOut(completion: {success in
                // do this on main thread
                DispatchQueue.main.async {
                    if success{
                        // present login
                        //show user login
                        let loginVC = LoginViewController()
                        //user cant swipe new view away
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC,animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }else{
                        // error occured
                        fatalError("Could not log out user")
                    }
                }
            })
        
        
        }))
        
        //iPad
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
        
    }

    

}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Handel cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}

