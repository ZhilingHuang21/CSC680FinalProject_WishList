//
//  UIAlert.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/1/22.
//
// Description: Different Style UIAlertContoller

import Foundation
import UIKit
import DatePickerDialog

class UIAlert{
    
    func UIAlertWithTextField(title: String, actionButton: String,ui: UIViewController ,data: @escaping (String)->()){
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
        ui.present(alertController, animated: true , completion: nil)
        
    }
    
    func UIAlertWithDatePicker(title: String, actionButton: String,  callback: @escaping (Date)->()){
        
        DatePickerDialog().show(title, doneButtonTitle: actionButton, cancelButtonTitle: "Cancel" , maximumDate: Date(), datePickerMode: .date){ date in
            if let date = date {
                callback(date)
            }
        }
    }
    
    func UIAlertSimpleFormat(title: String, message: String, rightButton: String,ui: UIViewController, callback: @escaping ()->() ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftButton = UIAlertAction(title: "Cancel", style: .cancel){(_) in }
        let rightButton = UIAlertAction(title: rightButton, style: .default){_ in
            callback()
        }
        alert.addAction(leftButton)
        alert.addAction(rightButton)
        ui.present(alert, animated: true , completion: nil)
        
    }
    
    
}
