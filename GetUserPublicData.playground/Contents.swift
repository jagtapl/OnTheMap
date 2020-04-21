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
urlString = "https://onthemap-api.udacity.com/v1/users/663134476073"

let url = URL(string: urlString)
var request = URLRequest(url: url!)
let session = URLSession.shared

print("execute GET User Data request \(request)")

/* good reply
 

 */

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

}
task.resume()


