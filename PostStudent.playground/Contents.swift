import UIKit
import Foundation
import PlaygroundSupport

import ModelForPlayGround


// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Add new student location"

var urlString = ""

// Add new student location
urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"

// uniqueKey - Get a student using unique account id
let body =
"""
{
    "firstName": "Lalit",
    "lastName": "Jagtap",
    "longitude": 1.0,
    "latitude": 2.0,
    "mapString": "Chicago, Illinois",
    "mediaURL": "lalit",
    "uniqueKey": "007",
    "objectID": "bqe2voh0s05mpe5senl0",
    "createdAt": "2020-04-19T11:02:58.216Z",
    "updatedAt": "2020-04-19T11:02:58.216Z"
}
"""

print(body.data(using: .utf8))


let url = URL(string: urlString)
var request = URLRequest(url: url!)
let session = URLSession.shared

request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = body.data(using: .utf8)
print("httpbody \(request.httpBody)")

print("execute POST request \(request)")

let task = session.dataTask(with: request) { data, response, error in
    if let error = error { // Handle error
        print("error: \(error)")
        return
    }
    
    print(String(data: data!, encoding: .utf8)!)
    
    guard let response = response as? HTTPURLResponse,
        (200...299).contains(response.statusCode) else {
            print("server error")
            return
    }
    
    print(response)
    if let mimeType = response.mimeType, mimeType == "application/json",
        let data = data,
        let dataString = String(data: data, encoding: .utf8) {
        print("received data: \(dataString)")

    }
}
task.resume()

/* JSON to Swift Struct
 
 // MARK: - Welcome
 struct Welcome: Codable {
     let createdAt, objectID: String

     enum CodingKeys: String, CodingKey {
         case createdAt
         case objectID = "objectId"
     }
 }

 
 */
