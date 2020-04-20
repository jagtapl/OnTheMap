import UIKit
import Foundation
import PlaygroundSupport

import ModelForPlayGround

// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true


var str = "Get Students using query parameters like limit, uniqeKey"
var urlString = ""

// all - Get all student locations
//urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"

// uniqueKey - Get a student using unique account id
urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=007"

// limit - Get student location for 10 student
//urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=1"

// order - prefixKey with negative sign ...default order is asecending
//urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=10"

// skip - With limit to paginate through results
//urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=2&skip=5"


let url = URL(string: urlString)
let request = URLRequest(url: url!)
let session = URLSession.shared

//print("execute GET request \(request)")

let task = session.dataTask(with: request) { data, response, error in
    if error != nil { // Handle error
        return
    }
    
//    print("print received data in readable .utf8")
//    print(String(data: data!, encoding: .utf8)!)
    
    // decode using Codable
    do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .iso8601
        
            guard let data = data else {
                print("failed to get data for student location")
                return
            }
        
            let studentLocations = try decoder.decode(StudentLocations.self, from: data)
//          completed(.success(user))
            print("decododed studentLocation instance")
            print("count of studentLocations \(studentLocations.results.count)")
        
            for sl in studentLocations.results {
                print(sl)
            }
            return
        
        } catch let DecodingError.keyNotFound(type, context) {
            print("Type \(type) mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
//                completed(.failure(.invalidFieldName))
                return
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type \(type) mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
//                completed(.failure(.invalidValueType))
                return
        } catch {
            print("failed to decode JSON for student location")
        }
}
task.resume()

