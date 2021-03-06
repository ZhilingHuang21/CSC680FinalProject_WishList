//
//  PrefileViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/2/22.
//

import UIKit
import FirebaseFirestore

class PrefileController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var birthday: UILabel!
    
    let netWorking = NetWorking()
    let uid = FirebaseAuth().getUid()
    let datehandler = DateHandler()
    let loginManager = LoginManager()
    let alertController = UIAlert()
    let homepage = HomeViewController()
    var isLoadingViewController = false
    let errorhandler = ErrorHandler()
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        self.loginManager.logOut()
    }
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~change user name~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @IBAction func ChangeUserName(_ sender: Any) {
        self.alertController.UIAlertWithTextField(title: "Edit Username", actionButton: "Edit",ui: self , data: EditUserNameAction(data:))
    }
    
    func EditUserNameAction(data: String){
        guard let uid = self.uid else{
            return
        }
        let data = [ "Username": data ]
        self.netWorking.updateDatetoFirebase(collection: "User", uid: uid , data: data, onSuccess: onSuccess, onError: onError)
        
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~change user birthday~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @IBAction func EditBirthday(_ sender: Any) {
        self.alertController.UIAlertWithDatePicker(title: "Edit Birthday", actionButton: "Edit", callback:EditBirthdayAction(date:))
        
    }
    
    func EditBirthdayAction(date: Date){
        guard let uid = self.uid else{
            return
        }
        let data = [ "Birthday": date ]
        self.netWorking.updateDatetoFirebase(collection: "User", uid: uid , data: data, onSuccess: onSuccess, onError: onError)
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~result handle~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func onSuccess(){
        self.viewDidLoad()
    }
    func onError(){
        self.errorhandler.showErrorAlert(ui: self, message: "May be friebase occur error"){}
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingViewController = true
        viewLoadSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoadingViewController {
            isLoadingViewController = false
        }
        else{
            viewLoadSetup()
        }
    }
    
    func viewLoadSetup(){
        self.updateInfo()
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~User info~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func updateInfo(){
        
        guard let uid = self.uid else{
            return
        }
        self.netWorking.readDataFromFrieBase(collection: "User", uid: uid){ [weak self] data in
            let username = data["Username"] as! String
            let birthday = data["Birthday"] as! FirebaseFirestore.Timestamp
            let date = birthday.dateValue()
            DispatchQueue.main.async {
                self?.setUsernameAndBirthday(username: username, birthday: date)
            }
            
        }
    }
    
    func setUsernameAndBirthday(username:String, birthday: Date){
        
        self.username.text = username
        let birthdayString = self.datehandler.getStringByDate(birthday, format: "MM-dd-yyyy")
        self.birthday.text = birthdayString
    }
}

