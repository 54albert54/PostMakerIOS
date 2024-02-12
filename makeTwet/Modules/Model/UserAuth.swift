//
//  UserAuth.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/11/24.
//

import Foundation
enum KeyStore:String{
    case userName
    case userPassword
}

struct UserAuth{
    private let userKey = "UserLogin"
    private let storage = UserDefaults.standard
    
    
    func saveDataStore(dato:String , key:KeyStore){
        
         storage.set(dato, forKey: key.rawValue)
    }
    func getDataStore(_ key:KeyStore) -> String{
        let storageUserData = storage.string(forKey: key.rawValue) ?? "no data"
       return storageUserData
   }
    
}
