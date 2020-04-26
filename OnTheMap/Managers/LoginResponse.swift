//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/21/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }
}

// MARK: - UdacityLogin
struct SessionResponse: Codable {
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case session
    }
}

// MARK: - Post Student Resonse
struct PostStudentResponse: Codable {
    let createdAt, objectID: String

    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
}

struct UserInfo : Codable {
    let first_name : String
    let last_name : String
    let key : String
}
