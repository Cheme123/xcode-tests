/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    var validation = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userField: DesignableTextField!
    @IBOutlet weak var signupOrLogin: UIButton!
    @IBOutlet weak var changeSignupMode: UIButton!
    @IBOutlet weak var message: UILabel!
    
    func createAlert(title: String, message: String) {
        
        // creates a generalized alert with message and title
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
            // options to dismiss the alert
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        //presents alert to user
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
       
        if (emailField.text == "" || passwordField.text == "" || userField.text == "") && signupMode == true {
            
            createAlert(title: "Error", message: "Please enter an email, a password, and a username")
            
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            // activity indicator that shows users login process
            
            if signupMode {
                
                // Sign Up -> User does not have an account
                
                let user = PFUser()
                
                ////// Start of Check of User Format
                let correctFormatUserName = userField.text
                let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
//                character set that may be within the username
                if correctFormatUserName?.rangeOfCharacter(from: characterset.inverted) != nil {
                    print("string contains special characters")
                    
                    
                    createAlert(title: "Incorrect Username", message: "Make sure your username  contains letters and numbers only, and is at least 6 characters long")
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
//                    checks if username only contains letters and numbers
                    validation = false
                ////// End of check of user format
                    
                    
                } else {
                    validation = true
                }
                
                if validation {
                    user.username = correctFormatUserName
                    // correctFormatUserName is username that is created if and ony if it has a valid format.
                    user.email = emailField.text
                    user.password = passwordField.text
                    
                    user.signUpInBackground(block: { (success, error) in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if error != nil {
                            
                            var displayErrorMessage = "Please try again later."
                            //basic error message
                            
                            if let errorMessage = (error! as NSError).userInfo["error"] as? String  {
                                displayErrorMessage = errorMessage
                                //gets message from parse
                                
                            }
                            
                            self.createAlert(title: "Sign Up Error", message: displayErrorMessage)
                            
                        } else {
                            print("User Signed Up")                            
                            self.performSegue(withIdentifier: "showUserTable", sender: self)
                            // transitions to User Profile
                        }
                    })
                }
                
                
            } else {
                // Log In Mode
                
                if validation {
                    PFUser.logInWithUsername(inBackground: userField.text!, password: passwordField.text!, block:  { (user, error) in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if error != nil {
                            
                            var displayErrorMessage = "Please try again later."
                            //basic error message
                            
                            if let errorMessage = (error! as NSError).userInfo["error"] as? String  {
                                displayErrorMessage = errorMessage
                                //gets message from parse
                                
                            }
                            
                            self.createAlert(title: "Log In Error", message: displayErrorMessage)
                            
                        } else {
                            print("User Logged In")
                            self.performSegue(withIdentifier: "showUserTable", sender: self)
                        }
                    })
                }
            }
        }
    }
    @IBAction func changeSignUpMode(_ sender: Any) {
        if signupMode {
            signupOrLogin.setTitle("Log In", for: [])
            changeSignupMode.setTitle("Sign Up", for: [])
            message.text = "Don't have an account?  "
            emailField.isHidden = true
            signupMode = false
        } else {
            signupOrLogin.setTitle("Sign up", for: [])
            changeSignupMode.setTitle("Log In", for: [])
            message.text = "Already have and account?"
            emailField.isHidden = false
            signupMode = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
        userField.text = ""
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
