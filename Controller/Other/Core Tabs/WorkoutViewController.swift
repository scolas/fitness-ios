//
//  WorkoutViewController.swift
//  Fitness
//
//  Created by Scott Colas on 1/18/21.
//

import UIKit
struct WorkoutFormModel{
    let label: String
    let placeholder: String
    //var so we can change as they type
    var value: String?
}
class WorkoutViewController: UIViewController, UITableViewDataSource {
    
    //no delegate because each row is going to have text filed
    //video 7 2min
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CreateWorkoutTableViewCell.self,
                           forCellReuseIdentifier: CreateWorkoutTableViewCell.identifier)
        return tableView
    }()
    private var models = [[WorkoutFormModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCancel))
    }
    
    private func configureModels(){
        //name , username , website, bilo
        let section1Labels = ["Name","Description"]
        var section1 = [WorkoutFormModel]()
        for label in section1Labels{
            let model = WorkoutFormModel(label: label,
                                             placeholder: "Enter \(label)...", value: nil)
            section1.append(model)
            
        }
        models.append(section1)
        // email, phone // gendar
        let section2Labels = ["Workout"]
        var section2 = [WorkoutFormModel]()
        for label in section2Labels{
            let model = WorkoutFormModel(label: label,
                                             placeholder: "Enter \(label)...", value: nil)
            section2.append(model)
            
        }
        models.append(section2)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // Table View
    private func createTableHeaderView() -> UIView{
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/4).integral)
        let size = header.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width-size)/2,
                                                        y: (header.height-size)/2,
                                                        width: size,
                                                        height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self,
                                     action: #selector(didTapChageProfilePicture),
                                     for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return header
    }
    @objc private func didTapProfilePhotoButton(){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Fitness.CreateWorkoutTableViewCell.identifier, for:indexPath) as! CreateWorkoutTableViewCell
        cell.configure(with: model)
        //cell.textLabel?.text = model.label
        //cell.delegate = self
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Workout Information"
    }
    
    //Action
    
    @objc private func didTapSave(){
        // save inof to database
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
  
    @objc private func didTapChageProfilePicture(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change profile picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "choose from Library", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }

}

extension WorkoutViewController: CreateWorkoutTableViewCellDelegate{
    func createWorkoutTableViewCell(_ cell: CreateWorkoutTableViewCell, didUpdateField updatedModel: WorkoutFormModel) {
        print(updatedModel.value ?? "nil")
    }
    
 
}

