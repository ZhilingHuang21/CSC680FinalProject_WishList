//
//  Networking.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/27/22.

// Description: All functions are about connecting to Firebase or some endpoint to geting data

import Foundation
import FirebaseDatabase
import FirebaseFirestore

class NetWorking {
    
    let db = Firestore.firestore()
    func getdb() -> Firestore {
        return self.db
    }
    
    // add Dictionary Type data to Firebase Friestore
    func addDataToFirebase (collection: String, data: [ String : Any ], uid: String ){
        self.db.collection(collection).document(uid).setData(data){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    // adding ArrayType data to Friebase Firestore
    func addArrayToFireBase(collection: String, data: [String],fieldName:String, uid :String, onSucess:@escaping ()->(),onError:@escaping ()->()){
        let docRef = self.db.collection(collection).document(uid)
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                docRef.updateData([ fieldName : FieldValue.arrayUnion(data)]){err in
                    if let err = err {
                        onError()
                        print("Error writing document: \(err)")
                    } else {
                        onSucess()
                        print("Document successfully written!")
                    }
                }
                
            }
            else{
                docRef.setData([fieldName: data]){err in
                    if let err = err {
                        onError()
                        print("Error writing document: \(err)")
                    } else {
                        onSucess()
                        print("Document successfully written!")
                    }
                }
            }
            
        }
        
    }
    
    
    // read data from firestore
    func readDataFromFrieBase(collection: String, uid:String, callback: @escaping ([String : Any])->()){
        let docRef = self.db.collection(collection).document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(){
                    callback(data)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // delete data
    func deleteItemfromArrayFireBase(collection: String, uid:String, data: [String],fieldName:String ,onScuess:@escaping ()->(), onError: @escaping ()->()){
        let docRef = self.db.collection(collection).document(uid)
        docRef.getDocument{(document, error) in
            if let document = document, document.exists {
                docRef.updateData([fieldName : FieldValue.arrayRemove(data)]){ err in
                    if let err = err {
                        onError()
                        print("Error writing document: \(err)")
                    }
                    else{
                        onScuess()
                        print("Document successfully Delete!")
                    }
                    
                }
                
            }
            else{
                print("Document does not exist")
            }
        }
    }
    
    // update data
    func updateDatetoFirebase(collection: String, uid: String, data: [String: Any], onSuccess: @escaping ()->(), onError:@escaping ()->()){
        let docRef = self.db.collection(collection).document(uid)
        
        docRef.updateData(data){ err in
            if let err = err {
                onError()
                print("Error writing document: \(err)")
            }
            else{
                onSuccess()
                print("Document successfully Update!")
            }
            
        }
    }
    
    // find equal data from friebase fireStore
    func findFirebaseDataIsEqualToData(collection: String,FieldName:String ,data: Any, onSuccess: @escaping ([Any])->(), onError: @escaping ()->()){
        self.db.collection(collection).whereField(FieldName, isEqualTo: data).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                        onError()
                        print("Error getting documents: \(err)")
                    } else {
                        onSuccess(querySnapshot!.documents)
                        
                    }
        }
        
    }
    
    
    
    
    func getAztroToday(sign: String , callback: @escaping (Aztro)->()){
        let headers = [
            "X-RapidAPI-Host": "sameer-kumar-aztro-v1.p.rapidapi.com",
            "X-RapidAPI-Key": "d1ab593279mshe6a80ba27a2a606p1970a1jsn78a3c3a668cf"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://sameer-kumar-aztro-v1.p.rapidapi.com/?sign=\(sign)&day=today")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Error: \(String(describing: error))")
            } else {
                let httpResponse = response as? HTTPURLResponse
                let decoder = JSONDecoder()
                guard let data = data else {
                    return
                }
                if httpResponse?.statusCode == 200 {
                    do {
                        let mydata = try decoder.decode(Aztro.self, from: data)
                        callback(mydata)
                    }
                    catch {
                        
                    }
                }
                
            }
    
        })

        dataTask.resume()
    }
    
}
