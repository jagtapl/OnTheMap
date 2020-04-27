//
//  MapViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/22/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: DataLoadingViewController,  MKMapViewDelegate {

    var students: [StudentInformation] {
        return NetworkManager.shared.studentArray
    }

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStudents()
    }
    
    @IBAction func reloadTapped(_ sender: Any) {
        reloadStudents()
    }
    
    func reloadStudents() {
      
        // remove from local
        var annotations = [StudentAnnotation]()
        for std in self.students {
            let studentdAnnotation = StudentAnnotation(std)
            annotations.append(studentdAnnotation)
        }
        self.mapView.removeAnnotations(annotations)
        
        // remove from NetworkManager cache
        NetworkManager.shared.studentArray.removeAll()
        
        getStudents()
    }
    
    func getStudents() {
        showLoadingView()
        
        NetworkManager.shared.getLatestStudents() { [weak self] (result) in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch (result) {
            case .success(let students):
                
                if students.isEmpty {
                    self.mapView.isHidden = true
                    let message = "No student locations data found. Something is wrong."
                    self.presentAlertOnMainThread(title: "No student data", message: message)
                    
                } else {
                    var annotations = [StudentAnnotation]()
                    
                    for std in self.students {
                        let studentdAnnotation = StudentAnnotation(std)
                        annotations.append(studentdAnnotation)
                    }
                    
                    DispatchQueue.main.async {
                        self.mapView.isHidden = false
                        self.mapView.addAnnotations(annotations)
                        self.view.bringSubviewToFront(self.mapView)
                    }
                }
                                
            case .failure(let error):
                
                self.presentAlertOnMainThread(title: "No student data", message: error.rawValue)
            }
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
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = view.annotation?.subtitle! {
                guard let url = URL(string: mediaURL), (url.scheme != nil) else {
                    let message = "Student has invalid media url."
                    presentAlertOnMainThread(title: "Invalid URL", message: message)
                    return
                }
        
                // show media url using Safari VC
                presentSafariVC(with: url)
            }
        }
    }
}
