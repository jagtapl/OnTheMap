//
//  InfoPostViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/24/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit
import MapKit

/*
 Use geocodeAddressString to find geocode.
 Completion handler will go to CLPlacemark and segue to a view where text can be entered.
 Create a submit function that use global session variable, CLPlacemark and text to make a posting and return true/false.
 Completion handler will dismiss the view if true.
 
 */
class InfoPostViewController: DataLoadingViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        guard let location = locationTextField.text else {
            print("display alert message that location can not be blank")
            return
        }
        // check
        
        guard let url = URL(string: urlTextField.text!) else {
            print("display aleart message that url is invalid")
            return
        }
        
        print("find geolocation for user specified location \(location)")
        getCoordinate(addressString: location) { (clLocationCoordinate2D, error) in
            
            if let error = error {
                print("place returned invalid geolocation with error as \(error)")
            }
            
            // add this location to the map VC loaded from storyboard
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoPostMapViewController") as! InfoPostMapViewController
            let annotation = MKPointAnnotation()
            annotation.coordinate = clLocationCoordinate2D
            annotation.title = location
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // update the MKAnnotation in the destination VC

        
    }
}

//        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
//            // [CLPlacemark]
//            // Error
//            if let placemark = placemark {
//                print("success : \(placemark)")
//                print("longitude \(placemark.first?.location?.coordinate.longitude)")
//                print("lattitude \(placemark.first?.location?.coordinate.latitude)")
//
//
//            } else {
//                print ("failed geocoding of location with error as \(String(describing: error))")
//            }
//        }
