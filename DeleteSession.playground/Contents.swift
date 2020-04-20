import UIKit
import Foundation
import PlaygroundSupport

import ModelForPlayGround


// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Delete session id to logout of Udacity"

var urlString = ""


// Add new student location
urlString = "https://onthemap-api.udacity.com/v1/session"


let url = URL(string: urlString)
var request = URLRequest(url: url!)
let session = URLSession.shared

request.httpMethod = "DELETE"
var xsrfCookie: HTTPCookie? = nil

let sharedCookieStorage = HTTPCookieStorage.shared

for cookie in sharedCookieStorage.cookies! {
  if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
}

if let xsrfCookie = xsrfCookie {
  request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
}

print("execute DELETE session request \(request)")

/* good reply
 
 {"session":{"id":"2383683456S868334a7fdb6e608e5134b7320af05cc","expiration":"2020-04-21T22:15:38.359093Z"}}

 
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


