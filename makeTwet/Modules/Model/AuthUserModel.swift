//
//  AuthUserModel.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation

// MARK: - AuthUser
struct AuthUser: Codable {
    var userName: String
    var password: String
    
}

// MARK: - AuthUser
struct AuthUserResponse: Codable {
    let error: Bool
    let body: BodyAt
}

// MARK: - Body
struct BodyAt: Codable {
    let showData: ShowData
    let token: String
}

// MARK: - ShowData
struct ShowData: Codable {
    let id: Int
    let name, userName: String
}
