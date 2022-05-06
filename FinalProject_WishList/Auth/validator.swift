//
//  validator.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/24/22.
//

// Validation for the user text input

import Foundation

protocol DataType {
    var type: String {get}
}

struct PasswordType: DataType {
    let type: String = "password"
}
struct EmailType : DataType{
    let type: String = "email"
}
struct  MaxLenght: DataType{
    let type: String = "maxLength"
    var value: Int
    init(val : Int = 130){
        self.value = val
    }

}
struct  MinLenght : DataType {
    let type: String = "minLength"
    var value: Int
    init(val: Int = 3){
        self.value = val
    }
}

struct Require: DataType {
    let type: String = "require"
}


class Validator {
    
    var data: String
    
    init(data: String){
        self.data = data
    }
    
    func isValueData(items : [DataType]) ->Bool{
        var isValue : Bool = true
        for item in items {
            if item.type == PasswordType().type {
                //Minimum eight characters, at least one letter and one number
                isValue = (isValue && self.data.range(of: #"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"#, options: .regularExpression) != nil)
                
            }
            if item.type == EmailType().type {
                isValue = (isValue && self.data.range(of: #"^\S+@\S+\.\S+$"#, options: .regularExpression) != nil)
            }
            if item.type == Require().type {
                isValue = (isValue && self.data.count > 0)
            }
            if item.type == MaxLenght().type {
                let itemA = item as! MaxLenght
                isValue = (isValue && self.data.count <= itemA.value)
            }
            if item.type == MinLenght().type {
                let itemA = item as! MinLenght
                isValue = (isValue && self.data.count >= itemA.value)
            }
        }
        return isValue
    }
    

}
