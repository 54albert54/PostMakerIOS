//
//  CreatePostModel.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/11/24.
//

import Foundation

struct CreatePostModel:Decodable ,Encodable  {
    var title:String
    var detail:String
    var img:String
    var videoUrl:String
    var latitude:Double
     var longitude:Double
}

struct CreatePostModelResponse:Decodable,Encodable  {
    var error:Bool
    var body:String
}



// location: [,postLocation!.longitude ]
