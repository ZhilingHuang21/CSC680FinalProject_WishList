//
//  HomeViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController {
    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var aztrodescription: UITextView!
    let networking = NetWorking()
    
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    
    var aztroInfo: Aztro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getData { user in
                self.greeting.text = "Hi, \(user.username)"
                self.uploadTodayAztro(user.birthday)
            }
        }
        
    }
    
    func uploadTodayAztro(_ birthday: String){
        let datehandler = DateHandler()
        let mydate = datehandler.getDateByString(birthday)
        guard let mysign = datehandler.FindYourConstellation(mydate) else {
            return
        }
        let mysignString = mysign.description
        networking.getAztroToday(sign: mysignString) {mysign in
            DispatchQueue.main.async {
                self.daliyHoroscpe(mydetail: mysign, mysign: mysignString)
            }
        }
    }
    
    
    func daliyHoroscpe(mydetail: Aztro, mysign: String){
        let text = "Daily Horoscope \n" +
                    "Dear, \(mysign) \n" +
        "Today: \(mydetail.description) \n" +
        "Your lucky color : \(mydetail.color) \n " +
        "Your lucky number: \(mydetail.lucky_number) \n" +
        "Your lucky time: \(mydetail.lucky_time)  \n" +
        "Your compatibility: \(mydetail.compatibility) \n" +
        "Your mood : \(mydetail.mood) \n"
        
        self.aztrodescription.text = text
    }
    
    
    
    
    
    func getData( _ callback: @escaping (User) -> Void ){
        guard let uid = currentUser?.uid else {
            return
        }
        ref.child("User").child(uid).observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                var user = User()
                user.username = dictionary["Username"] as! String
                user.email = dictionary["Email"] as! String
                user.birthday = dictionary["Birthday"] as! String
                callback(user)
            }
        })
        {(error) in
            print(error)
        }


    }
    
    
    
}
