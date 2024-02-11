//
//  PostData.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation

// MARK: - PostData
struct PostData: Codable {
    let error: Bool
    let body: BodyPd
}

// MARK: - Body
struct BodyPd: Codable {
    let id: Int
    let title, detail: String
    let ownerID: Int
    let ownerName: String
    let userThatLike: [UserThatLike]?

    enum CodingKeys: String, CodingKey {
        case id, title, detail
        case ownerID = "owner_id"
        case ownerName = "owner_name"
        case userThatLike
    }
}

// MARK: - UserThatLike
struct UserThatLike: Codable {
    let id: Int?
    let name: String?
}
