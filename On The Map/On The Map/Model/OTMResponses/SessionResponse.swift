//
//  SessionResponse.swift
//  On The Map
//
//  Created by Can Yıldırım on 24.02.2023.
//

import Foundation

struct LoginResponse : Codable {
    
    let account : Account
    let session : Session

}

struct Account : Codable {
    
    let registered : Bool
    let key : String
    
}

struct Session : Codable {
    
    let id : String
    let expiration : String
    
}






/* {

 "account":{
    "registered":true,
    "key":"3903878747"
},
"session":{
    "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
    "expiration":"2015-05-10T16:48:30.760460Z"
}
}

 */
