//
//  NetworkManager.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/20/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()

    private init() {
        // to make sure only one instance is created
    }

    struct Auth {
        static var userId = 0
        static var sessionId = ""
        static var loginResponse: LoginResponse?
    }
    
    enum Endpoints {
        static let baseURL = "https://onthemap-api.udacity.com/v1/session"
        
        case login
        case logout
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.baseURL + ""
            case .logout:
                return Endpoints.baseURL + ""
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func getUserId() -> String {
        return Auth.loginResponse?.account.key ?? ""
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginRequest = LoginRequest(username: username, password: password)
        let udacityLogin = UdacityLogin(udacity: loginRequest)
        

        taskForPOSTRequest(url: Endpoints.login.url, response: LoginResponse.self, body: udacityLogin) { (response, error) in
            if let response = response {
                Auth.loginResponse = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = body
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        print("execute POST session request \(request)")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)

            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                   completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
