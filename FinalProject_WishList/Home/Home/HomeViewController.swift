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

class RecentFriendCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var days: UILabel!
    
    
}
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var greeting: UILabel!
    
    @IBOutlet weak var mysign: UILabel!
    @IBOutlet weak var AztroDes: UITextView!
    @IBOutlet weak var luckyColor: UILabel!
    @IBOutlet weak var Compatibility: UILabel!
    @IBOutlet weak var luckyTime: UILabel!
    @IBOutlet weak var mood: UILabel!
    @IBOutlet weak var luckyNumber: UILabel!
    
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    
    let networking = NetWorking()
    let datehandler = DateHandler()
    
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    
    
    var recentThreeBirthdayGuys: [Friend] = []
    var friendList: [Friend] = []
    let dispatchGroup = DispatchGroup()
    
    
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
        self.friendList = []
        tableview.delegate = self
        tableview.dataSource = self
        DispatchQueue.main.async {
            self.updateHomeView()
        }
        self.getFriendUidArray()
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentThreeBirthdayGuys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentFriendCell") as? RecentFriendCell else {
            return UITableViewCell()
        }
        
        let friend = self.recentThreeBirthdayGuys[indexPath.row]
        cell.title.text = "\(friend.username) \n"
        let date: Date = friend.birthday!
        let nextBirthdy = datehandler.getNextbirthday(date)
        let days = datehandler.daysBetween(start: Date(), end: nextBirthdy)
        cell.days.text = " After \(days) days \n"
        cell.days.textColor = UIColor.systemPink
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToFriendWishListSegue", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let friendWishListViewController = segue.destination as? FriendWishlistViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        let friend = self.recentThreeBirthdayGuys[indexPath.row]
        friendWishListViewController.friend = friend
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
        let mydate = self.datehandler.getDateByString(birthday , format: "MM-d")
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
    
    
    func getFriendUidArray(){
        guard let uid = currentUser?.uid else {
            return
        }
        self.networking.readDataFromFrieBase(collection: "Friends", uid: uid){ data in
            DispatchQueue.main.async {
                if let uidArray = data["friendsUID"] as? [String] {
                    self.getUserDatabyArray(data: uidArray)
                    self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                        self.friendList = self.datehandler.sortArrayByClosingBirthday(data: self.friendList)
                        if self.friendList.count > 3 {
                            self.recentThreeBirthdayGuys = Array(self.friendList[0...3])
                        }
                        else{
                            self.recentThreeBirthdayGuys = self.friendList
                        }
                        self.tableview.reloadData()
                    })
                }
            }
        }
    }
    
    
    func getUserDatabyArray(data: [String]){
        for uid in data {
            self.dispatchGroup.enter()
            self.networking.readDataFromFrieBase(collection: "User", uid: uid ){ data in
                    let username = data["Username"] as! String
                let birthday = self.datehandler.getDatebyFirebaseTimestamp(data["Birthday"] as! FirebaseFirestore.Timestamp)
                    let email = data["Email"] as! String
                    let friend: Friend = Friend(uid: uid, birthday: birthday, email: email, username: username)
                    self.friendList.append(friend)
                self.dispatchGroup.leave()
            }
        }
        
    }
    
    
}
