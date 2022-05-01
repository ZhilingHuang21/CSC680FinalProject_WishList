//
//  NotificationName+Extensions.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/29/22.
//

import Foundation

extension NSNotification.Name{
    static var loggedIn: NSNotification.Name{
        NSNotification.Name(rawValue: "loggedIn")
    }
    static var loggedOut: NSNotification.Name{
        NSNotification.Name(rawValue: "loggedOut")
    }
}
