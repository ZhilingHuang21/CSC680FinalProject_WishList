//
//  FireBaseErrorHandler.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/6/22.
//
// Description: Hanlde error message and the way to show message

import Foundation
import FirebaseAuth

class ErrorHandler {
    
    func showErrorAlert(ui: UIViewController, message: String, callback: @escaping ()->()){
        let uiAlert = UIAlert()
        uiAlert.UIAlertSimpleFormat(title: "Error", message: message, rightButton: "OK", ui:ui){
            callback()
        }
    }
    
    func handleFirbaseAuthError(_ error : Error)->String{
        if let errorCode = AuthErrorCode(rawValue: error._code){
            return errorCode.errorMessage
        }
        return "Error Occurred"
    }
    
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already use"
        case .invalidEmail:
            return "Please enter a valid email"
        case .wrongPassword:
            return "Wrong password"
        default:
            return "Error occured"
        }
    }
}
