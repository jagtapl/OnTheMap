//
//  StudentAnnotation.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/23/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit
import MapKit

class StudentAnnotation: MKPointAnnotation {

    init(_ student: StudentInformation) {
        super.init()
        
        let lat = CLLocationDegrees(student.latitude)
        let long = CLLocationDegrees(student.longitude)
        
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.title = "\(student.firstName) \(student.lastName)"
        self.subtitle = student.mediaURL        
    }
}
