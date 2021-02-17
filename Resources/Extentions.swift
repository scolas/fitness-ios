//
//  Extentions.swift
//  Fitness
//
//  Created by Scott Colas on 1/10/21.
//

import UIKit

extension UIView{
    public var width: CGFloat{
        return frame.size.width
    }
    
    
    public var height: CGFloat{
        return frame.size.height
    }
    
    public var top: CGFloat{
        return frame.origin.y
    }
    
    public var bottom: CGFloat{
        return frame.origin.y + frame.size.height
    }
    
    
    
    public var left: CGFloat{
        return frame.origin.x
    }
    
    
    public var right: CGFloat{
        return frame.origin.x + frame.size.width
    }
    
}

extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormatter.string(from: date)
    }
}

extension String{
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}
