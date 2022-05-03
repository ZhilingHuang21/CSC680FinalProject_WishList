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
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            NotificationCenter.default.post(name: .loggedOut, object: nil, userInfo: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
