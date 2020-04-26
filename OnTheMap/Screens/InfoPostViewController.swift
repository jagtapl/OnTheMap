//
//  InfoPostViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/24/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit
import MapKit

class InfoPostViewController: DataLoadingViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        guard let location = locationTextField.text else {
            presentAlertOnMainThread(title: "Enter location", message: "user location can not be empty.")
            return
        }
        
        let enteredURL = "https://" + urlTextField.text!
        
        guard let url = URL(string: enteredURL), (url.scheme != nil) else {
            presentAlertOnMainThread(title: "Enter valid URL", message: "user media url can not be wrong.")
            return
        }
        
        getCoordinate(addressString: location) { (clLocationCoordinate2D, error) in
            
            if let error = error {
                let message = "received invalid geolocation with error as \(error.localizedDescription)"
                self.presentAlertOnMainThread(title: "Geolocation error", message: message)
            }
            
            // add this location to the map VC loaded from storyboard
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoPostMapViewController") as! InfoPostMapViewController
            let annotation = MKPointAnnotation()
            annotation.coordinate = clLocationCoordinate2D
            annotation.title = location
            annotation.subtitle = enteredURL
            destVC.userAnnotation = annotation
            
            // push that VC on the navigation
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    

    func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, Error?) -> Void ) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as Error?)
        }
    }
}
