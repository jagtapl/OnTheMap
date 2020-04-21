//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/20/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import Foundation

// MARK: - LoginRequest
struct LoginRequest : Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

// MARK: - UdacityLogin
struct UdacityLogin: Codable {
    let udacity: LoginRequest
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
