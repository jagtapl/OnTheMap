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
    static var loginResponse: LoginResponse?
    static var userInfo: UserInfo?

    var studentArray: [StudentInformation] = []

    private init() {
        // to make sure only one instance is created
    }


    
    enum Endpoints {
        static let baseURL = "https://onthemap-api.udacity.com/v1"
        static let studentDataURL = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case postStudentLocation
        case getLatestStudentLocations
        case getPublicUserData(String)
        case login
        case logout
        case webSignUp
        
        var stringValue: String {
            switch self {
            case .postStudentLocation:
                return Endpoints.baseURL + "/StudentLocation"
            case .getLatestStudentLocations:
                return Endpoints.baseURL + "/StudentLocation" + "?order=-updatedAt&limit=100"
            case .getPublicUserData(let userId):
                return Endpoints.baseURL + "/users/" + userId
            case .login:
                return Endpoints.baseURL + "/session"
            case .logout:
                return Endpoints.baseURL + "/session"
            case .webSignUp:
                return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Data api
    // Get student locations data for latest 100 students
    func postStudentLocation(location: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {

        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(location)
        
        print("execute post User Public Data session request \(request)")
        
        taskDataRequest(urlRequest: request, response: PostStudentResponse.self) { (response, error) in
            if error != nil {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func taskDataRequest<ResponseType: Decodable>(urlRequest: URLRequest, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8)!)

            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ResponseType.self, from: data)
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
    
    func getLatestStudents(completed: @escaping (Result<[StudentInformation], OTMError>) -> Void) {
        
        if studentArray.count > 0 {
            completed(.success(studentArray))
            return
        }
        
        // fetch it from network as no local cache exists
        let url = Endpoints.getLatestStudentLocations.url

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed (.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let studentLocations = try decoder.decode(StudentLocations.self, from: data)
                print("decododed studentLocation instance")
                print("count of studentLocations \(studentLocations.results.count)")
                let studentArray: [StudentInformation] = studentLocations.results
                
                // store local cache for future reuse
                self.studentArray = studentArray
                
                completed(.success(studentArray))
            } catch let DecodingError.keyNotFound(type, context) {
                print("Type \(type) mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completed(.failure(.invalidFieldName))
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type \(type) mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completed(.failure(.invalidValueType))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Session api
    func getUserId() -> String {
        return NetworkManager.loginResponse?.account.key ?? ""
    }
    
    func getUserPublicData(userKey: String, completion: @escaping (Bool, Error?) -> Void) {

        var request = URLRequest(url: Endpoints.getPublicUserData(userKey).url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("execute Get User Public Data session request \(request)")
        
        taskSessionRequest(urlRequest: request, response: UserInfo.self) { (response, error) in
            if let response = response {
                NetworkManager.userInfo = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
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
            if let _ = response {
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
                NetworkManager.loginResponse = response
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
