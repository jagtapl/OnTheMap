//
//  UIViewController+Ext.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/22/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        print("logout \( NetworkManager.shared.getUserId()) from Udacity")
        
        NetworkManager.shared.logout(completion: handleLogoutResponse(success:error:))
    }

    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
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
