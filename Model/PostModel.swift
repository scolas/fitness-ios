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
        for _ in 0...100 {
            let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "kanyewest",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                ), postType: .photo,
                likecount: [],
                 comments: [],
                 createdDate: Date(),
                 taggedUsers: [],
                category: BodyPart.abs,
                 owner: User(username: "scolas", profilePictureURL: URL(string: ""), identifier: "test")
            )
            posts.append(post)
        }
        return posts
    }

    /// Represents database child path for this post in a given user node
    var videoChildPath: String {
        return "videos/\(user.username.lowercased())/\(fileName)"
    }
}
