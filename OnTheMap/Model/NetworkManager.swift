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
        case webSignUp
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.baseURL + ""
            case .logout:
                return Endpoints.baseURL + ""
            case .webSignUp:
                return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func getUserId() -> String {
        return Auth.loginResponse?.account.key ?? ""
    }
    
    func logout(completion: @escaping (Bool, Error?) -> Void) {

        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil

        let sharedCookieStorage = HTTPCookieStorage.shared

        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }

        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

//        print("execute DELETE session request \(request)")

        taskSessionRequest(urlRequest: request, response: SessionResponse.self) { (response, error) in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let loginRequest = LoginRequest(username: username, password: password)
        let udacityLogin = UdacityLogin(udacity: loginRequest)

        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = udacityLogin
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
//        print("execute POST session request \(request)")
        
        taskSessionRequest(urlRequest: request, response: LoginResponse.self) { (response, error) in
            if let response = response {
                Auth.loginResponse = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func taskSessionRequest<ResponseType: Decodable>(urlRequest: URLRequest, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
//            print(String(data: newData, encoding: .utf8)!)

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
