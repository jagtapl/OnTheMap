//
//  ResultsViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/21/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutTapped(_ sender: UIButton) {
        print("logout \( NetworkManager.shared.getUserId()) from Udacity")
        
        NetworkManager.shared.logout(completion: handleLogoutResponse(success:error:))
    }

    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
//            self.performSegue(withIdentifier: "completeLogout", sender: nil)
            self.dismiss(animated: true, completion: nil)
        } else {
            showLogoutFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLogoutFailure(message: String) {
        let alertVC = UIAlertController(title: "Logout Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
