//
//  FirebaseAuth.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/1/22.
//

import Foundation
import FirebaseAuth

class FirebaseAuth {
    let currentUser = Auth.auth().currentUser
    
    func getUid()->String? {
        guard let uid = currentUser?.uid else{
            return nil
        }
        return uid
    }
    
    
    
}
