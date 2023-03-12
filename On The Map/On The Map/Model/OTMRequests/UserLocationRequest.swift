//
//  UserLocationRequest.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import Foundation

struct UserLocationRequest : Codable {
    
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double?
    let longitude : Double?
    let createdAt: String
    let updatedAt: String
    let objectId: String

}


