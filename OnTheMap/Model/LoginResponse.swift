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
