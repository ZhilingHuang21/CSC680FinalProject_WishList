//
//  LoginManager.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/29/22.
//

import Foundation
import FirebaseAuth

class LoginManager {
    func logIn(){
        NotificationCenter.default.post(name: .loggedIn, object: nil,userInfo: nil)
    }
    func logOut(){
        NotificationCenter.default.post(name: .loggedOut, object: nil, userInfo: nil)
    }
}
