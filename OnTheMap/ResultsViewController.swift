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
    }

}
