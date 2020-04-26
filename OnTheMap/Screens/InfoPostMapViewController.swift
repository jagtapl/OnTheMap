//
//  InfoPostMapViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/24/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit
import MapKit

class InfoPostMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var userAnnotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.userAnnotation)
            let theRegion = MKCoordinateRegion(center: self.userAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
            self.mapView.setRegion(theRegion, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .roundedRect)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
        let userId = NetworkManager.shared.getUserId()
        //get student information using key from account.key \(userId) in the login response"
        
        NetworkManager.shared.getUserPublicData(userKey: userId) { (success, error) in
            if success {

                if let userInfo = NetworkManager.userInfo {

                    let mapString:String = (self.userAnnotation.title)!!
                    let mediaUrl:String = (self.userAnnotation.subtitle)!!
                    
                    let postStudent = StudentInformation(firstName: userInfo.first_name, lastName: userInfo.last_name, longitude: self.userAnnotation.coordinate.longitude, latitude: self.userAnnotation.coordinate.latitude, mapString: mapString, mediaURL: mediaUrl, uniqueKey: userId, objectID: "", createdAt: "", updatedAt: "")
                    
                    NetworkManager.shared.postStudentLocation(location: postStudent) { (success, error) in
                        if success {
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            let message = error?.localizedDescription ?? "failed to student location"
                            self.presentAlertOnMainThread(title: "Failed to update student", message: message)
                        }
                    }
                }
            } else {
                let message = error?.localizedDescription ?? "failed to get public user data"
                self.presentAlertOnMainThread(title: "Failed to get public user data", message: message)
            }
        }

    }
}
