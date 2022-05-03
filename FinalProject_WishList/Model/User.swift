//
//  User.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/26/22.
//

import Foundation


import UIKit

struct UserInfo: Codable{
    var user : User
}

struct User : Codable {
    var email : String = ""
    var username : String = ""
    var password : String = ""
    var birthday : Date?
    
    func isValueSet() -> Bool{
        return !self.email.isEmpty && !self.password.isEmpty && !self.username.isEmpty
    }
    func isRepeatPassword(repeatPassword : String) -> Bool {
        if self.password.isEmpty {
            return false
        }
        else{
            return repeatPassword == password
        }
    }
    func getBaseType() -> [String: Any] {
        var data =  [String: Any]()
        if self.isValueSet() {
            data["Email"] = self.email
            data["Username"] = self.username
            data["Birthday"] = self.birthday
        }
        return data
    }
    
}


