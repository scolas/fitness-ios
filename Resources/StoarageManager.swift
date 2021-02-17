//
//  StoarageManager.swift
//  Fitness
//
//  Created by Scott Colas on 1/10/21.
//

import FirebaseStorage

public class StoreageManager{
    static let shared = StoreageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {}
    
    //public
    public func getVideoURL(with identfier: String, completion: (URL) -> Void){
        
    }
    
    public func uploadVideo(from url: URL,fileName: String, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        //metadata couldbe content type
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) {_, error in
            completion(error == nil)
            
        }
    }
    
    
    public func generateVideoName() -> String{
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
    
}
