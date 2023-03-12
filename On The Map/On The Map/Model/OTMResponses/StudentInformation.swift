//
//  StudentInformation.swift
//  On The Map
//
//  Created by Can Yıldırım on 2.03.2023.
//

import Foundation

struct StudentInformation : Codable {
    
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String?
    let mediaURL : String
    let latitude : Double
    let longitude : Double
    let createdAt: String
    let updatedAt: String
    let objectId: String
    
    init(_ dictionary: [String: AnyObject]) {
            self.createdAt = dictionary["createdAt"] as? String ?? ""
            self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
            self.firstName = dictionary["firstName"] as? String ?? ""
            self.lastName = dictionary["lastName"] as? String ?? ""
            self.mapString = dictionary["mapString"] as? String ?? ""
            self.mediaURL = dictionary["mediaURL"] as? String ?? ""
            self.latitude = dictionary["latitude"] as? Double ?? 0.0
            self.longitude = dictionary["longitude"] as? Double ?? 0.0
            self.objectId = dictionary["objectId"] as? String ?? ""
            self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        }

}
