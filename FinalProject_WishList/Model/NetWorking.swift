//
//  Networking.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 4/27/22.

import Foundation
import FirebaseDatabase
class NetWorking {
    
    private let ref = Database.database().reference()
    
    func addDataToFirebase (path: String, data: [ String : Any ], uid: String ){
        self.ref.child(path).child(uid).setValue(data)
        
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