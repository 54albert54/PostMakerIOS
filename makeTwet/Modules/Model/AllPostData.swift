//
//  AllPostData.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation


// MARK: - AllPostData
struct AllPostData: Codable {
    let error: Bool
    let body: [BodyAP]
}

// MARK: - Body
struct BodyAP: Codable {
    let id: Int
    let  title, detail , ownerUser ,videoUrl ,img: String
    let longitud:String
     let    latitud:String
    var hasLocation:Bool {
        self.longitud != "0.000000"
       }
       
}
