//
//  GFError.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 04/22/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import Foundation

enum OTMError: String, Error {
    case invalidStudentsURL = "Something wrong with url to fetch latest students"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case invalidFieldName = "The data received from the server contained a field that did not match."
    case invalidValueType = "The data received from the server contained a field that had unexpected value type."
}
