//
//  AuthManager.swift
//  Fitness
//
//  Created by Scott Colas on 1/10/21.
//


import Foundation
import FirebaseAuth

public class AuthManager{
    static let shared = AuthManager()
    let auth = Auth.auth()
    
    /// Private constructor
    private init() {}
    
    /// Represents method to sign in
    enum SignInMethod {
        /// Email and password method
        case email
        /// Facebook method
        case facebook
        /// Google Account method
        case google
    }

    /// Represents errors that can occur in auth flows
    enum AuthError: Error {
        case signInFailed
    }
    
    // Public

    /// Represents if user is signed in
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    
    public func registerNewUser(username: String,email:String, password:String, completion: @escaping (Bool) -> Void){
        /*
         - Check if username is available
         - Check if email is available
         - Create account
         - Insert account to database
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate{
                /*
                 - Create account
                 -  Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { ( result, error) in
                    guard error == nil, result != nil else{
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    //Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted{
                            completion(true)
                            return
                        }
                        else {
                            // Failed to insert to database
                            completion(false)
                            return
                        }
                        
                    }
                    
                }
            }
            else {
                //either username of email does not exist
                completion(false)
            }
            
        }
    }
    

    
    
    public func loginUserOld(username: String?, email:String?, password:
        String, completion: @escaping (Bool) -> Void) {
            if let email =  email{
                // email log in
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    guard authResult != nil, error == nil else{
                        // scope need to escape thats why we use @escaping
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
             
            }else if let username = username{
                // username log in
                print(username)
            }
    }
    
    public func loginUser(with email:String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            
                // email log in
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    guard result != nil, error == nil else{
                        // scope need to escape thats why we use @escaping
                        if let error = error{
                            completion(.failure(error))
                        }else{
                            completion(.failure(AuthError.signInFailed))
                        }
                        return
                    }
                    
                    DatabaseManager.shared.getUsername(for: email) { username in
                        if let username = username {
                            UserDefaults.standard.setValue(username, forKey: "username")
                            print("username is \(username)")
                        }
                        
                    }
                    
                    //successful sing in
                    completion(.success(email))
                }
    }
    
    public func logOut(completion: (Bool)-> Void){
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch  {
            print(error)
            completion(false)
           
            return
        }
    }
    
    /// Attempt to sign up
    /// - Parameters:
    ///   - username: Desired username
    ///   - emailAddress: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signUp(
        with username: String,
        emailAddress: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Make sure entered username is available

        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            UserDefaults.standard.setValue(username, forKey: "username")
            
            DatabaseManager.shared.insertNewUser(with: emailAddress, username: username, completion: completion)
        }
    }

    /// Attempt to sign out
    /// - Parameter completion: Async callback of sign out result
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }


}
