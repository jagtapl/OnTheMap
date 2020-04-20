import UIKit
import Foundation
import PlaygroundSupport

import ModelForPlayGround


// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "To authenticate Udacity API need a session id"

var urlString = ""


// Add new student location
urlString = "https://onthemap-api.udacity.com/v1/session"

let body =
"""
{
    "udacity": {
        "username": "jagtap_lalit@yahoo.com",
        "password": "lalvast"
    }
}
"""

/* good reply
 {"account":{"registered":true,"key":"41183074"},"session":{"id":"3138890281S73f7fe87ded70cc155a2229724e9d78e","expiration":"2020-04-21T21:53:16.535531Z"}}

 for
 "username": "jlalit2001@yahoo.com",
 "password": "onthemap2020"
 "
 */

/*
 {"account":{"registered":true,"key":"663134476073"},"session":{"id":"6640714442S28ac04f6117b1c26e4788368578c9618","expiration":"2020-04-21T21:58:39.405709Z"}}
 
 "udacity": {
     "username": "jagtap_lalit@yahoo.com",
     "password": "lalvast"
 }
 */

/* JSON to Swift Struct
 
 // MARK: - Welcome
 struct Welcome: Codable {
     let account: Account
     let session: Session
 }

 // MARK: - Account
 struct Account: Codable {
     let registered: Bool
     let key: String
 }

 // MARK: - Session
 struct Session: Codable {
     let id, expiration: String
 }
 
 */

print(body.data(using: .utf8))


let url = URL(string: urlString)
var request = URLRequest(url: url!)
let session = URLSession.shared

request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Accept")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = body.data(using: .utf8)
print("httpbody \(request.httpBody)")

print("execute POST session request \(request)")

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


