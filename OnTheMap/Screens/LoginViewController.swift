//
//  ViewController.swift
//  OnTheMap
//
//  Created by LALIT JAGTAP on 4/20/20.
//  Copyright © 2020 LALIT JAGTAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
        
        if ((self.emailTextField.text?.count == 0) || (self.passwordTextField.text?.count == 0)) {
            let message = "You must provide login user id and password"
            presentAlertOnMainThread(title: "Login Failed", message: message)
            setLogingIn(false)
            return
        }
        
        NetworkManager.shared.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpViaWebsiteTapped() {
        setLogingIn(true)

        UIApplication.shared.open(NetworkManager.Endpoints.webSignUp.url, options: [:], completionHandler: nil)
        
        setLogingIn(false)
    }
    
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogingIn(false)
        
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            presentAlertOnMainThread(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
}

