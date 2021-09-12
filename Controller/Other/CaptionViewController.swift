//
//  CaptionViewController.swift
//  Fitness
//
//  Created by Scott Colas on 2/7/21.
//
import TTGTagCollectionView
import ProgressHUD
import UIKit

class CaptionViewController: UIViewController,RadioButtonDelegate , TTGTextTagCollectionViewDelegate{
    func onClick(_ sender: UIView) {
        
    }
    
    private var selections = [String]()
    
    let radioButton = RadioButton()
    
    let videoURL: URL
    
    let tagCollection = TTGTextTagCollectionView()

    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    init(videoURL: URL){
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
        radioButton.delegate = self

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost))
        tagCollection.alignment = .center
        tagCollection.delegate = self
        view.addSubview(captionTextView)
        view.addSubview(radioButton)
        view.addSubview(tagCollection)
        
        let config = TTGTextTagConfig()
        config.backgroundColor = .systemBlue
        config.textColor = .white
        config.borderColor = .systemOrange
        config.borderWidth = 1
        
        tagCollection.addTags(["Arms","Chest","Abs"], with: config)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top+5, width: view.width-10, height: 150).integral
        radioButton.frame = CGRect(x: 5, y: captionTextView.bottom, width: view.width-10, height: 150).integral
        tagCollection.frame = CGRect(x: 0, y: captionTextView.bottom+100, width: view.frame.width, height: 300)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
   

    @objc private func didTapPost(){
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        let tagging = "Arms"
        //generate video name that is unique based on id
        
        let newVideoName = StoreageManager.shared.generateVideoName()
        ProgressHUD.show("Uploading")
        //upload vid
        StoreageManager.shared.uploadVideo(from: videoURL, fileName: newVideoName){ [weak self] success in
            DispatchQueue.main.async {
                if success {
                    //update database
                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: caption, tags: tagging) {databaseUpdated in
                        if databaseUpdated {
                            HapticsManager.shared.vibrate(for: .success)
                            ProgressHUD.dismiss()
                            //reset camera and switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        }else {
                            HapticsManager.shared.vibrate(for: .error)
                            ProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Shit!", message: "Your video did not get uploaded. try again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self?.present(alert, animated: true)
                        }
                    }
                    
                    
                    
                }else{
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Shit!", message: "Your video did not get uploaded. try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
            
        }
       
    }
    //https://www.youtube.com/watch?v=dKe59TavIEc
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        selections.append(tagText)
        
        print("\(selections)")
    }
}
