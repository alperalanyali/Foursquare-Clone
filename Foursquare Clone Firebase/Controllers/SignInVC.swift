//
//  ViewController.swift
//  Foursquare Clone Firebase
//
//  Created by Alper on 19.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {
    
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        self.view.addGestureRecognizer(hideKeyboardGR)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    fileprivate func alertSetup(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sigInTapped(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().signIn(withEmail:emailField.text! , password: passwordField.text!) { (result, error) in
                if error != nil {
                    self.alertSetup(message: (error?.localizedDescription)!)
                } else {
                    print("Successfully Sign In")
                    UserDefaults.standard.set(self.emailField.text!, forKey: "userLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogIn()
                    
                }
            }
        } else {
            self.alertSetup(message: "Email and password are required.")
        }
        
    }
    @IBAction func signUpTapped(_ sender: Any) {
        if emailField.text! != "" && passwordField.text! != "" {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
                if error != nil {
                    self.alertSetup(message: (error?.localizedDescription)!)
                } else {
                    print("Successfully Sign Up")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
        } else {
            self.alertSetup(message: "Email and password are required.")
        }
    }
    
    
    
    
    
    
    
    
    
    
}
