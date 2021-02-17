//
//  Notifications.swift
//  Fitness
//
//  Created by Scott Colas on 2/12/21.
//

import Foundation

enum Notificationtype{
    case postLike(postName: String )
    case userFollow(username: String)
    case postComment(postName: String )
    
    var id: String{
        switch self {
        case .postLike: return "postLike"
        case .userFollow: return "userFollow"
        case .postComment: return "postComment"
                
        }
    }
}
class Notification {
    var identifier = UUID().uuidString
    var isHidden = false
    let text: String
    let type: Notificationtype
    let date: Date
    
    init(text: String, type: Notificationtype, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification] {
        let first = Array(0...5).compactMap({
            Notification(
                text: "Something happened: \($0)",
                type: .postComment(postName: "sdfsdfsd"),
                date: Date()
            )
        })

        let second = Array(0...5).compactMap({
            Notification(
                text: "Something happened: \($0)",
                type: .userFollow(username: "sdfsdfsd"),
                date: Date()
            )
        })

        let third = Array(0...5).compactMap({
            Notification(
                text: "Something happened: \($0)",
                type: .postLike(postName: "sdfsdfsd"),
                date: Date()
            )
        })

        return first + second + third
    }
}
