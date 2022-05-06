//
//  WishListViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/1/22.
//

import UIKit
import FirebaseDatabase

class WishItemCell: UITableViewCell{
    
}

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let uiAlert = UIAlert()
    let networking = NetWorking()
    private var wishItems: [String] = []
    let errorhandler = ErrorHandler()
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func AddItemPressed(_ sender: Any) {
        uiAlert.UIAlertWithTextField(title: "Add Wish Item", actionButton: "Add",ui: self, data: addItem(item:))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetUp()
    }
    
    
    func viewLoadSetUp(){
        navigationItem.title = "Wish List"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(WishItemCell.self, forCellReuseIdentifier: "WishItemCell")
        readItems()
    }
    

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~add tab button~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func addItem(item: String){
        guard let uid = FirebaseAuth().getUid() as String? else{
            return
        }
        let itemArray:[String]  = [item]
        self.networking.addArrayToFireBase(collection: "WishItem", data: itemArray, fieldName: "items", uid: uid, onSucess: onScuess, onError: onError)
    }

//~~~~~~~~~~~~~~~~~~read data and upload to table view~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    func readItems() {
        guard let uid = FirebaseAuth().getUid() as String? else{
            return
        }
        self.networking.readDataFromFrieBase(collection: "WishItem", uid: uid){ [weak self] data in
            let item = data["items"] as! [String]
            self?.tableviewUpdate(with: item)
        }
    }
    func tableviewUpdate(with data: [String]){
        DispatchQueue.main.async {
            self.wishItems = data
            self.tableview.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "WishItemCell") as? WishItemCell else{
            return UITableViewCell()
        }
        let item = wishItems[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = FirebaseAuth().getUid() as String? else{
            return
        }
        let item = wishItems[indexPath.row]
        let data = [item]
        if editingStyle == .delete {
            self.networking.deleteItemfromArrayFireBase(collection: "WishItem", uid: uid, data: data, fieldName: "items",onScuess: onScuess ,onError: onError)
        }
    }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
    func onScuess(){
        self.viewDidLoad()
    }
    func onError(){
        self.errorhandler.showErrorAlert(ui: self, message: "Error Occurred"){}
    }
    
}
