import UIKit
import Foundation
import PlaygroundSupport

import ModelForPlayGround


// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Update existing student using objectID"

var urlString = ""


// Add new student location
urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/bqeq15a137i05qjse4l0"

let body =
"""
{
    "uniqueKey": "007",
    "firstName": "Lalit_jse4l0",
    "lastName": "Jagtap_jse4l0",
    "mapString": "Deerfield, Illinois",
    "mediaURL": "lalit",
    "longitude": 33.0,
    "latitude": 44.0
}
"""



print(body.data(using: .utf8))


let url = URL(string: urlString)
var request = URLRequest(url: url!)
let session = URLSession.shared

request.httpMethod = "PUT"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = body.data(using: .utf8)
print("httpbody \(request.httpBody)")

print("execute PUT request \(request)")

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

}
task.resume()

/* JSON to Swift Struct
 
 // MARK: - Welcome
 struct Welcome: Codable {
     let updatedAt: String
 }
 
 */

