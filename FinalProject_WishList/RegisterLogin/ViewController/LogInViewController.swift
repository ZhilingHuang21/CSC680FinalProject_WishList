//
//  LogInViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/28/22.
//

import UIKit
import FirebaseAuth

struct LoginUser {
    var email: String = ""
    var password: String = ""
}


class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailMessage: UILabel!
    
    @IBOutlet weak var passwordMessage: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var user = LoginUser()
    
    var loginManager = LoginManager()
    let errorhandler = ErrorHandler()
    
    @IBAction func loginPressed(_ sender: Any) {
        if !self.user.email.isEmpty && !self.user.password.isEmpty {
            print(self.user)
            FirebaseSignin()
        }
        
    }
    
    func FirebaseSignin(){
        Auth.auth().signIn(withEmail: self.user.email, password: self.user.password) { authResult, error in
            if error != nil {
                print("Error: \(String(describing: error))")
                let errormessage = self.errorhandler.handleFirbaseAuthError(error!)
                self.errorhandler.showErrorAlert(ui: self, message: errormessage){}
            }
            else{
                print("Login  success")
                self.loginManager.logIn()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetUp()
    }
    func viewLoadSetUp(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailTextField {
            guard let text = textField.text else{
                return
            }
            let isValue = Validator(data: text).isValueData(items: [EmailType(),Require()])
            if isValue {
                self.user.email = text
                emailMessage.text = ""
            }
            else{
                emailMessage.text = "Not the email correct format"
                emailMessage.textColor = UIColor.systemRed
            }
        }
        if textField == passwordTextField {
            guard let text = textField.text else {
                return
            }
            let isValue = Validator(data: text).isValueData(items: [PasswordType(),Require()])
            if isValue {
                self.user.password = text
                passwordMessage.text = ""
            }
            else{
                passwordMessage.text = "Not the password correct format"
                passwordMessage.textColor = UIColor.systemRed
            }
        }
    }
    
    
    
    
    
    
}
