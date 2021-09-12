//
//  PostModel.swift
//  Fitness
//
//
//

import Foundation

public enum UserPostTypeFormat: String{
    case photo = "Photo"
    case video = "Video"
}


struct PostModel {
    let identifier: String
    let user: User
    var fileName: String = ""
    var caption: String = ""
    let postType: UserPostTypeFormat
    let likecount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let category: BodyPart
    let owner: User

    var isLikedByCurrentUser = false

    static func mockModels() -> [PostModel] {
      var posts = [PostModel]()
        /*for _ in 0...5 {
            let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "kanyewest",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                ),fileName: "https://i2.wp.com/qui2health.com/wp-content/uploads/2020/02/75554010_178559103288651_8254203824522381638_n.jpg?fit=1080%2C1242&ssl=1",
                postType: .photo,
                likecount: [],
                 comments: [],
                 createdDate: Date(),
                 taggedUsers: [],
                category: BodyPart.abs,
                 owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
            )
            posts.append(post)
        }*/
        return posts
    }
    
    static func mockModels2(part: BodyPart) -> [PostModel] {
        var posts = [PostModel]()
       
        /*  let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "kanyewest",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                ),fileName: "https://i.pinimg.com/originals/79/f0/14/79f014a31c85b20aca132e959ba149c6.jpg",
                postType: .photo,
                likecount: [],
                 comments: [],
                 createdDate: Date(),
                 taggedUsers: [],
                category: BodyPart.abs,
                 owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
            )
        let post1 = PostModel(
            identifier: UUID().uuidString,
            user: User(
                username: "kanyewest",
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),fileName: "https://media.self.com/photos/58a34c9c37f75e231dae7240/master/w_1600%2Cc_limit/Screen%2520Shot%25202017-02-14%2520at%25201.29.24%2520PM.png",
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.legs,
             owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
        )
        let post2 = PostModel(
            identifier: UUID().uuidString,
            user: User(
                username: "kanyewest",
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),fileName: "https://media.self.com/photos/58a358c19d6f39ff71b333af/master/w_1600%2Cc_limit/Screen%2520Shot%25202017-02-14%2520at%25202.21.21%2520PM.png",
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.arms,
             owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
        )
        let post3 = PostModel(
            identifier: UUID().uuidString,
            user: User(
                username: "kanyewest",
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),fileName: "https://i.dailymail.co.uk/i/pix/2018/02/14/01/49300C4F00000578-5388607-Roping_em_in_Kevin_Hart_is_set_to_expose_his_audience_to_all_new-a-17_1518571339202.jpg",
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.chest,
             owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
        )
        let post4 = PostModel(
            identifier: UUID().uuidString,
            user: User(
                username: "kanyewest",
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),fileName: "https://cdn.shopify.com/s/files/1/0482/4380/2272/products/hero-4.jpg?v=1601670033",
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.chest,
             owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
        )
        let post44 = PostModel(
            identifier: UUID().uuidString,
            user: User(
                username: "kanyewest",
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),fileName: "https://i2.wp.com/qui2health.com/wp-content/uploads/2019/01/walk.gif?fit=440%2C440&ssl=1",
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.abs,
             owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
        )
        let post5 = PostModel(
            identifier: UUID().uuidString,
            user: User(
                username: "kanyewest",
                profilePictureURL: nil,
                identifier: UUID().uuidString
            ),fileName: "https://images.milledcdn.com/2019-05-12/eDLpxxDtA0jaTXWg/K94JrcGkTjb1.jpg",
            postType: .photo,
            likecount: [],
             comments: [],
             createdDate: Date(),
             taggedUsers: [],
            category: BodyPart.arms,
             owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
        )
           
        if(part == BodyPart.legs){
            return [post4,post5]
        }
        if(part == BodyPart.chest){
            return [post,post2]
        }
        if(part == BodyPart.abs){
            return [post3,post1]
        }
        else{
            return [post,post1,post2, post3, post4,post44, post5]
        }
        */
        return []
    }

    /// Represents database child path for this post in a given user node
    var videoChildPath: String {
        return "videos/\(user.username.lowercased())/\(fileName)"
    }
}
