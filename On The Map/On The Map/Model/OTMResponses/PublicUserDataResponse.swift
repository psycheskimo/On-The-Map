//
//  PublicUserDataResponse.swift
//  On The Map
//
//  Created by Can Yıldırım on 3.03.2023.
//

import Foundation

struct PublicUserDataRespone : Codable {
    
    let firstName : String
    let lastName : String
    let nickname : String
    
    enum CodingKeys : String, CodingKey {
        
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
   
    }
 
}
