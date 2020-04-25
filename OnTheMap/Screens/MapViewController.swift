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

    var students: [StudentInformation] = []

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStudents()
    }
    
    @IBAction func reloadTapped(_ sender: Any) {
        print("reload button tapped to load students data")
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
    
        self.students.removeAll()
    
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
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: "No student data", message: message, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    self.students.append(contentsOf: students)
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
                
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "No student data", message: error.rawValue, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                }
            
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
                    print("media url is not valid \(mediaURL)")
        
                    let message = "Student has invalid media url."
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(title: "Invalid URL", message: message, preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
        
                    return
                }
        
                // show media url using Safari VC
                presentSafariVC(with: url)
//                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                
            }
        }
        
    }
    

}
