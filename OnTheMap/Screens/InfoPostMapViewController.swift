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

        // Do any additional setup after loading the view.
//        DispatchQueue.main.async {
//            self.mapView.addAnnotation(self.userAnnotation)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.userAnnotation)
            var theRegion = MKCoordinateRegion(center: self.userAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
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
        // use network manager to submit the location to server
        
        // use the account key from the login response
        // get the user information using key (get public api)
        
        // use that to update location and url and post student
        
        print("get student information using key from account.key in the login response")
        print("next post the student information to update the location and media url")
        
    }

}
