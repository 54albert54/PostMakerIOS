//
//  ApiManager.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation
import Alamofire

struct ApiPostManager{
    
   
    
   static func getAllPost(){
        
        let urlPoint = EndPoin.postUrl
        AF.request(urlPoint,method:.get,parameters: nil).responseData {(response:AFDataResponse<Data>) in
        if response.error != nil{
        
            return
        }
            if let safeData = response.data {
            let decode = JSONDecoder()
            do{
                let decodeData = try decode.decode(AllPostData.self, from: safeData ) as AllPostData
           
            }catch{
                print("mas error")
                return
            }
        }
        }
    }
    func getPost(id:Int ){
        if id > 0{
            let urlPoint = EndPoin.postUrl + "\(id)"
            AF.request(urlPoint,method:.get,parameters: nil).responseData {(response:AFDataResponse<Data>) in
            if response.error != nil{
                print("error")
                return
            }
                if let safeData = response.data {
                let decode = JSONDecoder()
                do{
                    let decodeData = try decode.decode(PostData.self, from: safeData ) as PostData
                
                }catch{
                    print("mas error")
                    return
                }
            }
        }
        }else{
            print("id no puede ser 0")
        }
    }
}




