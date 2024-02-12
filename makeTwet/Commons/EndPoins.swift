//
//  EndPoins.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation

struct EndPoin{
    // Server Remote "https://server-apipost.onrender.com/api/"
    // Server local  "http://localhost:4000/api/"

    static  let endPoin = "https://server-apipost.onrender.com/api/"
  static  let authUrl = EndPoin.endPoin + "auth/login"
  static let postUrl = EndPoin.endPoin + "post/"
  static let addUserUrl = EndPoin.endPoin + "user"
    
}

