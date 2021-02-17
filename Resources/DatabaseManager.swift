//
//  DatabaseManager.swift
//  Fitness
//
//  Created by Scott Colas on 1/10/21.
//

import FirebaseDatabase


public class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
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
    
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void){
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
                "caption": caption
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
        }
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
}
