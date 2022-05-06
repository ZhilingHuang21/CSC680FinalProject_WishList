//
//  Friends.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/4/22.
//

import Foundation

struct Friends: Codable {
    var friends : [Friend]
}

struct Friend : Codable {
    var uid : String
    var birthday : Date?
    var email : String
    var username : String
}
