//
//  OTMClient.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        
        static let baseURL = "https://onthemap-api.udacity.com"
        
        case getStudentLocation
        case postUserLocation
        case updateUserLocation
        case login
        case signUp
        case getPublicUserData
        
        var url : URL {
            
            return URL(string: stringValue)!
            
        }
        
        var stringValue : String {
            
            switch self {
                
            case .getStudentLocation : return Endpoints.baseURL + "/v1/StudentLocation?order=-updatedAt"
            case .postUserLocation : return Endpoints.baseURL + "/v1/StudentLocation"
            case .updateUserLocation : return Endpoints.baseURL + "/v1/StudentLocation/\(Auth.objectId)"
            case .login : return Endpoints.baseURL + "/v1/session"
            case .getPublicUserData : return Endpoints.baseURL + "/v1/users/" + Auth.key
            case .signUp : return "https://auth.udacity.com/sign-up"
                
            }
        }
    }
    
    class func getPublicUserData(completion: @escaping (Bool, Error?) -> Void) {
        
        taskForGetRequest(url: Endpoints.getPublicUserData.url, apiType: "udacity", responseType: PublicUserDataRespone.self) { response, error in
            
            if let response = response {
                
                print("firstname: \(response.firstName), lastname: \(response.lastName), nickname: \(response.nickname)")
                
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                
                
                completion(true, nil)
                
            } else {
                
                print("Failed to get user's data")
                completion(false, error)
                
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
       
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if error != nil {
                return
            }
            
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range)
            Auth.sessionId = ""
            print(String(data: newData!, encoding: .utf8)!)
            completion()
            
        }
        
        task.resume()
        
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        taskForPostRequest(url: Endpoints.login.url, apiType: "udacity", httpCode: "POST", responseType: LoginResponse.self, body: body) { response, error in
            
            if let response = response {
                
                Auth.key = response.account.key
                Auth.sessionId = response.session.id
                completion(true, nil)
                
            }
            
            completion(false, error)
            
        }

    }
    
    class func updateUserLocation(info: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = "{\"uniqueKey\": \"\(info.uniqueKey)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString ?? "")\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
        
        taskForPostRequest(url: Endpoints.updateUserLocation.url, apiType: "", httpCode: "PUT", responseType: UpdateResponse.self, body: body) { response, error in
            
            if let response = response, response.updatedAt != nil {
                
                completion(true, nil)
                
            }
        
            completion(false, error)
        
        }
         
    }

    class func postUserLocation(info: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = "{\"uniqueKey\": \"\(info.uniqueKey)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString ?? "")\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
        
        taskForPostRequest(url: Endpoints.postUserLocation.url, apiType: "", httpCode: "POST", responseType: UserLocationResponse.self, body: body) { response, error in
            
            if let response = response, response.createdAt != nil {
                 
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            
            }
            
            completion(false, error)
            
        }

    }
    
    class func getStudentLocation(completion: @escaping ([StudentInformation], Error?) -> Void) {
        
        taskForGetRequest(url: Endpoints.getStudentLocation.url, apiType: "", responseType: StudentLocationResponse.self) { response, error in
            
            if let response = response {
                
                completion(response.results, nil)

            } else {
                
                completion([], error)
                
            }
        
        }

    }
    
    class func taskForGetRequest<ResponseType: Decodable> (url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.sync {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            if apiType == "udacity" {
                
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                print(String(data: newData, encoding: .utf8)!)
                
                do {
                    
                    let response = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.sync {
                        completion(response, nil)
                    }
                    
                } catch {
                    DispatchQueue.main.sync {
                        completion(nil, error)
                    }
                    
                }
                
            } else {
                
                do {
                    let response = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.sync {
                        completion(response, nil)
                    }
                    
                } catch {
                    DispatchQueue.main.sync {
                        completion(nil, error)
                    }
                }
                
            }
        }
        
        task.resume()
   
    }
    
    class func taskForPostRequest<ResponseType: Decodable> (url: URL, apiType: String, httpCode: String, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        
        if httpCode == "POST" {
            
            request.httpMethod = "POST"
           
        } else {
            
            request.httpMethod = "PUT"
        }
        
        if apiType == "udacity" {
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        } else {
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                
                DispatchQueue.main.sync {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                if apiType == "udacity" {
                    
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let response = try decoder.decode(ResponseType.self, from: newData)
                    
                    DispatchQueue.main.sync {
                        completion(response, nil)
                    }
                    
                    
                } else {
                    
                    let response = try decoder.decode(ResponseType.self, from: data)
                    
                    DispatchQueue.main.sync {
                        completion(response, nil)
                    }
                }
            } catch {
                
                DispatchQueue.main.sync {
                    completion(nil, error)
                }
            
            }

        }
        
        task.resume()

        }

    }
    


