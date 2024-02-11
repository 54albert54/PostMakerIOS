//
//  ApiManager.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import Foundation
import Alamofire

struct ApiPostManager{
    
   
    
    func getAllPost(){
        
        let urlPoint = EndPoin.postUrl
        AF.request(urlPoint,method:.get,parameters: nil).responseData {(response:AFDataResponse<Data>) in
        if response.error != nil{
            print("erro")
            return
        }
            if let safeData = response.data {
            let decode = JSONDecoder()
            do{
                let decodeData = try decode.decode(AllPostData.self, from: safeData ) as AllPostData
                print(decodeData)
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
                print("erro")
                return
            }
                if let safeData = response.data {
                let decode = JSONDecoder()
                do{
                    let decodeData = try decode.decode(PostData.self, from: safeData ) as PostData
                    print(decodeData)
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




