//
//  NewUserRequest.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation

struct NewUserRequest :Decodable ,Encodable{
    let name:String
    let password:String
    let secondPassword:String
    let userName:String
}


// MARK: - NewUserResponse
struct NewUserResponse: Codable {
    let error: Bool
    let body: BodyRP
}

// MARK: - Body
struct BodyRP: Codable {
    let title: String
    let newDataUser: NewDataUser
}

// MARK: - NewDataUser
struct NewDataUser: Codable {
    let name, password, userName: String
}

