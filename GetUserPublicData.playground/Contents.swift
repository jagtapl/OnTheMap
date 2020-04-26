import UIKit
import Foundation
import PlaygroundSupport

import ModelForPlayGround


// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Getting users public data using user id"

var urlString = ""


// Add new student location
//urlString = "https://onthemap-api.udacity.com/v1/users/jagtap_lalit@yahoo.com"
//urlString = "https://onthemap-api.udacity.com/v1/users/jagtap.lalit@gmail.com"
//urlString = "https://onthemap-api.udacity.com/v1/users/41183074"
urlString = "https://onthemap-api.udacity.com/v1/users/6468442117"

let url = URL(string: urlString)
var request = URLRequest(url: url!)
let session = URLSession.shared
request.httpMethod = "GET"
request.setValue("application/json", forHTTPHeaderField: "Accept")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
print("execute GET User Data request \(request)")

/* good reply
 

 */

struct UserInfo : Codable {
    let first_name : String
    let last_name : String
    let key : String
}


let task = session.dataTask(with: request) { data, response, error in
    if let error = error { // Handle error
        print("error: \(error)")
        return
    }
    
    guard let response = response as? HTTPURLResponse,
        (200...299).contains(response.statusCode) else {
            print("server error")
            return
    }
    
    guard let data = data else {
        print("error: no data received")
        return
    }
    
    let range = (5..<data.count)
    let newData = data.subdata(in: range)
    print(String(data: newData, encoding: .utf8)!)
    
//    print(response)
    let decode = JSONDecoder()
    do {
        let responseObject = try decode.decode(UserInfo.self, from: newData)
        print(responseObject)
    }
    catch{
        print(error.localizedDescription)
    }

}
task.resume()

// This will fail because it needs to have a session. So using this request without session id fails.
// Thats why it is confusing


/*
 
 {"user":{"bio":null,"_registered":true,"linkedin_url":null,"_image":null,"guard":{"allowed_behaviors":["register","view-public","view-short"]},"location":null,"key":"3903878747","timezone":null,"_image_url":null,"nickname":"","website_url":null,"occupation":null}}

 
 
 struct User: Codable {
     let bio: JSONNull?
     let registered: Bool
     let linkedinURL, image: JSONNull?
     let userGuard: Guard
     let location: JSONNull?
     let key: String
     let timezone, imageURL: JSONNull?
     let nickname: String
     let websiteURL, occupation: JSONNull?

     enum CodingKeys: String, CodingKey {
         case bio
         case registered = "_registered"
         case linkedinURL = "linkedin_url"
         case image = "_image"
         case userGuard = "guard"
         case location, key, timezone
         case imageURL = "_image_url"
         case nickname
         case websiteURL = "website_url"
         case occupation
     }
 }
 
 
 */
