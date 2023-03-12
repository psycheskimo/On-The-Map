//
//  Data.swift
//  On The Map
//
//  Created by Can Yıldırım on 1.03.2023.
//

import Foundation

struct Data {
     
    static var data = [[String : Any]]()
    
    static func addData() {
        
        OTMClient.getStudentLocation { data, error in
            if let data = data {
                
                Data.data = data
                
            } else {
                
                print(error!)
            }
        }
        
        
    }
    
    
    
}


