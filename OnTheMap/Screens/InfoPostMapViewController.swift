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
    
    /*
        use network manager to submit the location to server
        use the account key from the login response
        get the user information using key (get public api)
        use that to update location and url and post student
    */
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
        let userId = NetworkManager.shared.getUserId()
        print("get student information using key from account.key \(userId) in the login response")
        
        NetworkManager.shared.getUserPublicData(userKey: userId) { (success, error) in
            if success {
                print("Success to get public user data \(String(describing: NetworkManager.userInfo))")

                if let userInfo = NetworkManager.userInfo {

                    let mapString:String = (self.userAnnotation.title)!!
                    let mediaUrl:String = (self.userAnnotation.subtitle)!!
                    
                    print("next post the student information to update the location and media url")

                    let postStudent = StudentInformation(firstName: userInfo.first_name, lastName: userInfo.last_name, longitude: self.userAnnotation.coordinate.longitude, latitude: self.userAnnotation.coordinate.latitude, mapString: mapString, mediaURL: mediaUrl, uniqueKey: userId, objectID: "", createdAt: "", updatedAt: "")
                    
                    print(postStudent)
                    NetworkManager.shared.postStudentLocation(location: postStudent) { (success, error) in
                        if success {
                            print("success in updating user location and media url")
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            print("failed to post updated location and media url for logged in user")
                        }
                    }
                }
            } else {
                print("Failed to get public userd data")
            }
        }

    }
}
