//
//  SearchViewController.swift
//  Fitness
//
//  Created by Scott Colas on 1/31/21.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {
 
    var tableView = UITableView()
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    var models2 =  [Search]()
    
    private var collectionView: UICollectionView?
    
    private var tabbedSerachCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0.4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSearchBar()
        configureTableView()

       
    }
    
   
    
    
    private func configureSearchBar(){
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.pin(to: view)
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
        //set delegates
        //set row height
        //register cell
        //set contraints
        
    }

    func setTableViewDelegates(){
        //self is VideoListVC
        //so we have to go and comform videolistVC to delegat and datasource
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        models2 = []
        query(text)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didCancelSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }){ done in
            if done {
                self.tabbedSerachCollectionView?.isHidden = false
            }
        }
    }


    @objc private func didCancelSearch(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem  = nil
        self.tabbedSerachCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations:  {
            self.dimmedView.alpha = 0
        }){ done in
            if done {
                self.dimmedView.isHidden = true
            }
           
        }
        
    }

    private func query(_ text: String) {
        
        let database = Database.database().reference()
        var works = [Search]()
        database.child("tags").child(text).observeSingleEvent(of: .value) { snapshot in
            
            
            if let dict = snapshot.value as? [String: [String: Any]] {
                
                for(key, value) in dict {
                     let vid = value
                          let n = vid["username"] as? String
                          let u = vid["name"] as? String
                    self.models2.append(Search(image: UIImage(named: "test")!  , name: n ?? "", username: u ?? ""))
                }
              
                
               
            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }else{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
           
            
            /*for(key, val) in videos {
                      let n = val["name"] as? String
                      let u = val["username"] as? String
                      let i = val["image"] as? String
                self.models2.append(Search(image: UIImage(named: "test")!  , name: n ?? "", username: u ?? ""))
                
            }*/
 
        }
      
    }
    
    
    

}

extension SearchViewController: VideoCellDelegate{
    func videoCell(_ cell: VideoCell, didTapAddWorkoutFor username: String) {
        print("videocell tappy tap")
    }
    
    
}


extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models2.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier) as! VideoCell
        let video = models2[indexPath.row]
        cell.set(video: video)
        cell.configure(with: video.name, model: video)
        return cell
    }
}


extension SearchViewController {
    func fetchData() -> [Search]{
        let video1 = Search(image: UIImage(named: "test")!, name: "test", username: "test")
        let video2 = Search(image: UIImage(named: "test")!, name: "2021", username: "21 savage")
        let video3 = Search(image: UIImage(named: "test")!, name: "2021", username: "21 savage")
        //let m = query("")
       // return m
        return [video1,video2,video3]
    }
}
