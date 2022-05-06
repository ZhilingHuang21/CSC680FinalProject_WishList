//
//  FriendWishlistViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/4/22.
//

import Foundation
import UIKit

class FriendWishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let networking = NetWorking()
    var friend : Friend?
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var birthday: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    var wishList:[String] = []
    
    var isLoadingViewController = false
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
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(WishItemCell.self, forCellReuseIdentifier: "WishItemCell")
        navigationItem.title = "Wish List"
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~update user info~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func updateInfo(){
        guard let friend = friend else {
            return
        }
        self.username.text = friend.username
        self.birthday.text = DateHandler().getStringByDate(friend.birthday!, format: "MMM d")
        self.email.text = friend.email
        self.getFriendWishList(uid: friend.uid)
        
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~geting friend uid~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func getFriendWishList(uid: String){
        self.networking.readDataFromFrieBase(collection: "WishItem", uid: uid){ [weak self] data in
            DispatchQueue.main.async {
                let wishlist = data["items"] as! [String]
                self?.wishList = wishlist
                self?.tableview.reloadData()
            }
            
        }
    }
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~tableview~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "WishItemCell") as? WishItemCell else{
            return UITableViewCell()
        }
        let item = wishList[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    
    
    
}
