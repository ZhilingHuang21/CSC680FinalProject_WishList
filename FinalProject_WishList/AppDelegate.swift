//
//  AppDelegate.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/24/22.
//

import UIKit
import Firebase
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        FirebaseApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userHasLoggedIn(_:)), name: .loggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userHasLoggedOut(_:)), name: .loggedOut, object: nil)
        
        userHasLoggedOut(nil)
        return true
    }
    @objc func userHasLoggedIn(_ notification: Notification){
        let user = Auth.auth().currentUser
        if user != nil {
            let storyboard = UIStoryboard(name: "WishlistHome", bundle: nil)
            
            guard let vc = storyboard.instantiateViewController(withIdentifier: "UINavigationController") as? UINavigationController else{
                return
            }
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
        else{
            
        }
        
    }
    @objc func userHasLoggedOut(_ notification: Notification?){
        let storyboard = UIStoryboard(name: "RegisterLogIn", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "UINavigationController") as? UINavigationController else {
            return
        }
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
    }

}

