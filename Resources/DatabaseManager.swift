//
//  DatabaseManager.swift
//  Fitness
//
//  Created by Scott Colas on 1/10/21.
//

import FirebaseDatabase
import FirebaseFirestore

struct tag{
    let name: String
    let username: String
}
public class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    private init() {}
    let database1 = Firestore.firestore()
    
    
    /// Find users with prefix
    /// - Parameters:
    ///   - usernamePrefix: Query prefix
    ///   - completion: Result callback
    /*public func findUsers(
        with usernamePrefix: String,
        completion: @escaping ([User]) -> Void
    ) {
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
                  error == nil else {
                completion([])
                return
            }
            let subset = users.filter({
                $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
            })

            completion(subset)
        }
    }
    */
    
    /// Inserts new user data to database
    /// -Parameters
    ///     - email: String represing email
    ///      - username:  String represintgn username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)-> Void){
        completion(true)
    }
    
    /// Inserts new user data to database
    /// -Parameters
    ///     - email: String represing email
    ///     - username:  String represintgn username
    ///     - completion :  Async callback for result if result if database entry succeded
    public func insertNewUser(with email: String, username: String, completion: @escaping(Bool) -> Void){
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]
                ) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }

            usersDictionary[username] = ["email": email]
            // save new users object
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
        /*database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            if error == nil {
                // succeeded
                completion(true)
                return
            }
            else {
                // failed
                completion(false)
                return
            }
        }*/
        
    }
    
    
    public func getUsername(for email: String, completion: @escaping(String?) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
        // in a large scale system this will be too slow 
            for( username, value) in users {
                if value["email"] as? String == email{
                    completion(username)
                    break
                }
            }
            
        }
    }
    
   
    
    func getWorkouts(for email: String, completion: @escaping(String?) -> [String: Any]) -> [tag]{
        
            var works = [tag]()
            self.database.child("tags").child("Arms").observeSingleEvent(of: .value) { snapshot in
                guard let videos = snapshot.value as? [String: [String: Any]] else {
                    completion(nil)
                    return
                }
                
                /*for(key, value) in videos {
                     let vid = value
                          let n = vid["name"] as? String
                          let u = vid["username"] as? String
                     works.append(tag(name: n ?? "", username: u ?? ""))
                }*/
                
               
            }
        return works
    }
    
    public func insertPost(fileName: String, caption: String, tags: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            let newEntry = [
                "name":fileName,
                "username": caption,
                "image": "test"
            ]
            
            //array of dictionaries
            if var posts = value["posts"] as? [[String: Any]]{
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value) { error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }else{
                // if no post exist
                
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) { error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                completion(true)
                }
            }
            
           
            self!.insertNewCategory(with: fileName, tag: tags, user: username) { inserted in
                if inserted{
                    completion(true)
                    print("insert new cat working")
                    return
                }
                else {
                    // Failed to insert to database
                    completion(false)
                    print("insert not new cat not working")
                    return
                }
            }
            

        }
    }
    
    
    
    public func insertNewCategory(with fileName: String, tag: String, user: String, completion: @escaping(Bool) -> Void){
        let newEntry = [
            "image": "test",
            "name": fileName,
            "username": user
        ]
        database.child("tags").child(tag).childByAutoId().setValue(newEntry)
        
        /*database.child("tags").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
                let newEntry = [
                    "name": fileName
                ]
                */
                
      
               /* self?.database.child("tags").setValue(
                    [newEntry
                        /*tag: [
                            "name": fileName
                        ]*/
                        
                    ]
                ) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }*/
           
                //array of dictionaries
           /* if var tags = usersDictionary["tags"] as? [[String: Any]]{
                    tags.append(newEntry)
                    usersDictionary["tags"] = tags
                self?.database.child("tags").childByAutoId().setValue(fileName) { error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                }else{
                    // if no post exist
                    
                    usersDictionary["tags"] = newEntry
                    self?.database.child("tags").childByAutoId().setValue(fileName) { error, _ in
                        guard error == nil else{
                            completion(false)
                            return
                        }
                    completion(true)
                    }
                }*/

            
            //}

   

        
    }


    public func follow(username: String, completion: @escaping (Bool) -> Void){
        completion(true)
    }
     func getNotifications(completion: @escaping ([Notification]) -> Void){
        completion(Notification.mockData())
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void){
        completion(true)
    }
    
    /// Update follow status for user
    /// - Parameters:
    ///   - user: Target user
    ///   - follow: Follow or unfollow status
    ///   - completion: Result callback
    func updateVideo(
        for user: User,
        follow: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }

        if follow {
            // follow

            // Insert into current user's following
            let path = "users/\(currentUserUsername)/following"
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToInsert = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                } else {
                    self.database.child(path).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }

            // Insert in target users followers
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToInsert = currentUserUsername.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                } else {
                    self.database.child(path2).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        } else {
            // unfollow

            // Remove from current user following
            let path = "users/\(currentUserUsername)/following"
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToRemove = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove })
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }

            // Remove in target users followers
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToRemove = currentUserUsername.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove })
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
    }
}
