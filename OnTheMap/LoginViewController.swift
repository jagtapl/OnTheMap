//
//  ViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/20/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    func setLogingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLogingIn(true)
        
        NetworkManager.shared.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        
//        TMDBClient.getRequestToken(completion: handleRequstTokenResponse(success:error:))
    }
    
//    func handleRequstTokenResponse(success: Bool, error: Error?) {
//        if success {
//            TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
//        } else {
//            showLoginFailure(message: error?.localizedDescription ?? "")
//        }
//    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLogingIn(true)
//        TMDBClient.getRequestToken { (success, error) in
//            if success {
//                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
//            }
//        }
    }
    
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogingIn(false)
        
        if success {
//            TMDBClient.createSession(completion: handleSessionResponse(success:error:))
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
//    func handleSessionResponse(success: Bool, error: Error?) {
//        setLogingIn(false)
//
//        if success {
//            self.performSegue(withIdentifier: "completeLogin", sender: nil)
//        } else {
//            showLoginFailure(message: error?.localizedDescription ?? "")
//        }
//    }
    
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }


}

