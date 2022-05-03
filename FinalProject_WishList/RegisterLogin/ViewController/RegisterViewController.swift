//
//  RegisterViewController.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/24/22.
//



/*
 UI Tag
 1 == email
 2 == username
 3 == password
 4 == confirm password
 */
import UIKit
import FirebaseDatabase
import FirebaseAuth




class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    private var passwordIsValue : Bool = false
    var userInfo = User()
    
    @IBOutlet weak var emailMessage: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var nameMessage: UILabel!
    
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordMessage: UILabel!
    
    @IBOutlet weak var repeatPasswordInput: UITextField!
    @IBOutlet weak var repeatPasswordMessage: UILabel!
    
    let networking = NetWorking()
    @IBAction func donePressed(_ sender: Any) {
        dataPickerSetter()
        if self.passwordIsValue && userInfo.isValueSet(){
            FirebaseAuth()
        }
    }
    func FirebaseAuth(){
        let data = self.userInfo.getBaseType()
        Auth.auth().createUser(withEmail: self.userInfo.email, password: self.userInfo.password) { authResult, error in
            if (error != nil) {
                print("Error in Signs up Account. Error \(String(describing: error))")
               
            }
            else{
                print("success")
                guard let userUid = Auth.auth().currentUser?.uid else {
                    return
                }
                self.networking.addDataToFirebase(collection: "User", data: data, uid: userUid )
                let loginManager = LoginManager()
                loginManager.logIn()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoadSetup()
        // Do any additional setup after loading the view
    }
    
    func viewLoadSetup(){
        navigationItem.title = "Register"
        emailInput.delegate = self
        userNameInput.delegate = self
        passwordInput.delegate = self
        repeatPasswordInput.delegate = self
    }
    
    
    
    
    
    
    func dataPickerSetter(){
        birthdayPicker.maximumDate = Date()
        userInfo.birthday = birthdayPicker.date
    }
    
    
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailInput {
            guard let text = textField.text else {
                            return
            }
            let isValue = Validator(data: text).isValueData(items: [EmailType(),Require()])

            if isValue {
                emailMessage.text = "✅"
                userInfo.email = text
            }
            else{
                emailMessage.text = "Please Enter correct Email Format"
                emailMessage.textColor=UIColor.systemRed
                
            }
    
        }
        else if textField == userNameInput {
            guard let text = textField.text else{
                return
            }
            let isValue = Validator(data: text).isValueData(items: [Require(),MinLenght(val: 3),MaxLenght(val:13)])
            
            if isValue {
                nameMessage.text = "✅"
                userInfo.username = text
            }
            else{
                nameMessage.text = "Please Enter UserName and must over 3 char"
                nameMessage.textColor = UIColor.systemRed
            }

    }
        else if textField == passwordInput {
            guard let text = textField.text else {
                return
            }
            let isValue = Validator(data: text).isValueData(items: [Require(), PasswordType()])
            
            if isValue{
                passwordMessage.text = "✅"
                userInfo.password = text
            }
            else{
                passwordMessage.text = "Min 8 chars At least 1 letter and 1 number "
                passwordMessage.textColor = UIColor.systemRed
            }
        }
        else if textField == repeatPasswordInput {
            guard let text = textField.text else {
                return
            }
            
            let isValue = !userInfo.password.isEmpty && userInfo.isRepeatPassword(repeatPassword: text)
            
            if isValue {
                repeatPasswordMessage.text = "✅"
                self.passwordIsValue = true
            }
            else {
                repeatPasswordMessage.text = "Repeat your password"
                repeatPasswordMessage.textColor = UIColor.systemRed
            }
        }
}
}
