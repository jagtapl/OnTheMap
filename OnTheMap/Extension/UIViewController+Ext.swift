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
    
    func presentAlertOnMainThread(title: String, message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    @IBAction func pinBarButtonTapped(_ sender: Any) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoPostViewController") as! InfoPostViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
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
            presentAlertOnMainThread(title: "Logout Failed", message: error?.localizedDescription ?? "")
        }
    }
}
