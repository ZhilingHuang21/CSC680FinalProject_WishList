//
//  HomeViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/29/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore


class HomeViewController: UIViewController {
    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var mysign: UILabel!
    @IBOutlet weak var AztroDes: UITextView!
    @IBOutlet weak var luckyColor: UILabel!
    @IBOutlet weak var Compatibility: UILabel!
    @IBOutlet weak var luckyTime: UILabel!
    @IBOutlet weak var mood: UILabel!
    @IBOutlet weak var luckyNumber: UILabel!
    
    @IBOutlet weak var Avatar: UIImageView!
    
    let networking = NetWorking()
    let datehandler = DateHandler()
    
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    
    var aztroInfo: Aztro?
    var isLoadingViewController = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingViewController = true
        viewLoadSetUp()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoadingViewController {
            isLoadingViewController = false
        }
        else{
            viewLoadSetUp()
        }
    }
    
    
    func viewLoadSetUp(){
        DispatchQueue.main.async {
            self.updateHomeView()
        }
    }
    
    
    
    
    func updateHomeView(){
        guard let uid = currentUser?.uid else {
            return
        }
        self.networking.readDataFromFrieBase(collection: "User", uid: uid){ data in
            let username = data["Username"] as! String
            guard let birthday = data["Birthday"] as? FirebaseFirestore.Timestamp else {
                return
            }
            let birthdayDate = birthday.dateValue()
            let birthdayString = self.datehandler.getStringByDate(birthdayDate,format: "MM-d")
            self.greeting.text = "Hi, \(username)"
            self.uploadTodayAztro(birthdayString)
        }
    }
    
    func uploadTodayAztro(_ birthday: String){
        let mydate = self.datehandler.getDateByString(birthday)
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
        
        self.mysign.text = "Dear, \(mysign)"
        self.AztroDes.text = "Today: \(mydetail.description)"
        self.luckyColor.text = "Color: \(mydetail.color)"
        self.luckyTime.text = "Lucky Time: \(mydetail.lucky_time)"
        self.luckyNumber.text = "Lucky #: \(mydetail.lucky_number)"
        self.Compatibility.text = "Compatibility: \(mydetail.compatibility)"
        self.mood.text = "Mood: \(mydetail.mood)"
        
    }
    
    
}
