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
    let uiAlert = UIAlert()
    let errorhandler = ErrorHandler()
    

    @IBAction func addFriendsPressed(_ sender: Any) {
        self.showAddFriendUIAlert()
    }
    
    
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
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~tableview~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Add Friend handle~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func showAddFriendUIAlert(){
        uiAlert.UIAlertWithTextField(title: "Enter Friend's Email", actionButton: "Add", ui: self , data: addFriendsToFriebase(data:))
    }
    
    func addFriendsToFriebase(data:String){
        self.networking.findFirebaseDataIsEqualToData(collection: "User", FieldName: "Email", data: data, onSuccess: onSuccess(data:), onError: onError)
    }
    func onSuccess(data: [Any]){
        guard let myuid = uid else {
            return
        }
        if data.count == 1 {
            let uid = (data[0] as AnyObject).documentID
            self.networking.addArrayToFireBase(collection: "Friends", data: [uid!], fieldName: "friendsUID", uid: myuid, onSucess: onSucessAddFriend, onError: onError)
        }
        else{
            self.onError()
        }
    }
    func onError(){
        self.errorhandler.showErrorAlert(ui: self , message: "this email not exist or error occor"){}
        
    }
    func onSucessAddFriend(){
        self.viewDidLoad()
    }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~geting friends infomation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func getFriendUidArray(){
        guard let uid = uid else {
            return
        }
        self.networking.readDataFromFrieBase(collection: "Friends", uid: uid){[weak self] data in
            guard let strongSelf = self else{
                return
            }
            DispatchQueue.main.async {
                if let uidArray = data["friendsUID"] as? [String] {
                    strongSelf.getUserDatabyArray(data: uidArray)
                    strongSelf.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                        strongSelf.friendList = strongSelf.datehandler.sortArrayByClosingBirthday(data: strongSelf.friendList)
                        strongSelf.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    
    func getUserDatabyArray(data: [String]){
        for uid in data {
            self.dispatchGroup.enter()
            self.networking.readDataFromFrieBase(collection: "User", uid: uid ){ [weak self] data in
                    let username = data["Username"] as! String
                let birthday = self?.datehandler.getDatebyFirebaseTimestamp(data["Birthday"] as! FirebaseFirestore.Timestamp)
                    let email = data["Email"] as! String
                    let friend: Friend = Friend(uid: uid, birthday: birthday, email: email, username: username)
                    self?.friendList.append(friend)
                self?.dispatchGroup.leave()
            }
        }
        
    }
    
    
    
}
