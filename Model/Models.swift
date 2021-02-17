//
//  Models.swift
//  Instagram
//
//  Created by Scott Colas on 1/13/21.
//

import Foundation

enum Gender{
    case male, female, other
}
enum BodyPart{
    case chest, legs, arms, abs, other
}
struct UserOld{
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let profilePhoto: URL
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}
struct User{
    let username: String
    let profilePictureURL: URL?
    let identifier: String
}
struct UserCount{
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType: String{
    case photo = "Photo"
    case video = "Video"
}

/// Represents a user post
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let postUrl: URL // either video or full photo
    let thumbnailImage: URL
    let caption: String?
    let likecount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
    let category: BodyPart
    let owner: User
    
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}
