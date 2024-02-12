//
//  isDev.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/11/24.
//

import Foundation

struct IsSimulate{
    
    static func isDev()->Bool{
       var result = true
#if targetEnvironment(simulator)
       result = true
   print("Estás corriendo en el simulador")
#else
   print("Estás corriendo en un dispositivo físico")
        result = false
#endif
        print("que sera de esta vida \(result)")
       return result
   }
    
    
}
