//
//  FriendsViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/4/22.
//

import UIKit
import FirebaseFirestore


class FriendsCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
}


class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var isLoadingViewController = false
    let dispatchGroup = DispatchGroup()
    let uid = FirebaseAuth().getUid()
    let networking = NetWorking()
    let datehandler = DateHandler()
    var FriendUid: [String] = []
    var friendList: [Friend] = []
    

    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingViewController = true
        viewLoadSetUp()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoadingViewController {
            isLoadingViewController = false
            self.friendList = []
        }
        else{
            viewLoadSetUp()
        }
    }
    func viewLoadSetUp(){
        self.friendList = []
        navigationItem.title = "Friends"
        tableView.delegate = self
        tableView.dataSource = self
        self.getFriendUidArray()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell") as? FriendsCell else {
            return UITableViewCell()
        }
        
        let friend = friendList[indexPath.row]
        cell.title.text = "\(friend.username) \n"
        let date: Date = friend.birthday!
        let dateString = datehandler.getStringByDate(date, format: "MMM d")
        cell.subtitle.text = "\(dateString) \n"
        cell.subtitle.textColor = UIColor.systemPink
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToFriendWishListViewSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let friendWishListViewController = segue.destination as? FriendWishlistViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        let friend = self.friendList[indexPath.row]
        friendWishListViewController.friend = friend
    }
    
    
    
    
    
    
    
    func getFriendUidArray(){
        guard let uid = uid else {
            return
        }
        self.networking.readDataFromFrieBase(collection: "Friends", uid: uid){ data in
            DispatchQueue.main.async {
                if let uidArray = data["friendsUID"] as? [String] {
                    self.getUserDatabyArray(data: uidArray)
                    self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                        self.friendList = self.datehandler.sortArrayByClosingBirthday(data: self.friendList)
                        self.tableView.reloadData()
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
