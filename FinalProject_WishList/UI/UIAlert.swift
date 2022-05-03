//
//  UIAlert.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/1/22.
//

import Foundation
import UIKit
import DatePickerDialog

class UIAlert{
    
    func UIAlertWithTextField(title: String, actionButton: String,callback:@escaping (UIAlertController)->(), data: @escaping (String)->()){
        let alertController = UIAlertController(title: title , message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: actionButton, style: .default ) { (_) in
            if let textInput = alertController.textFields?.first, let text = textInput.text {
                data(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(_) in }
        
        alertController.addTextField{ (textField) in
            
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        callback(alertController)
    }
    
    func UIAlertWithDatePicker(title: String, actionButton: String,  callback: @escaping (Date)->()){
        
        DatePickerDialog().show(title, doneButtonTitle: actionButton, cancelButtonTitle: "Cancel" , maximumDate: Date(), datePickerMode: .date){ date in
            if let date = date {
                callback(date)
            }
        }
    }
    
    
}
