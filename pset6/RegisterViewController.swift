//
//  RegisterViewController.swift
//  pset6
//
//  Created by Ayanna Colden on 09/12/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    var ref:FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        // Check if login field is filled correctly.
        if emailText.text! == "" && passwordText.text == "" {
            self.alertError()
        }
        
        if passwordText.text != confirmPasswordText.text {
            self.alertError()
        }
        
        // Create user and log them in.
        FIRAuth.auth()!.createUser(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
            if error != nil {
                self.alertError()
                return
            }
            FIRAuth.auth()!.signIn(withEmail: self.emailText.text!, password: self.passwordText.text!)
        }
        
        // Alert and login.
        let alert = UIAlertController(title: "Register", message: "You are now a member of MiWine", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "loginAfterRegister", sender: self)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)

    }
    
    // Error Alert.
    func alertError() {
        let alert = UIAlertController(title: "Email and/or password(s) invalid", message: "Enter matching passwords and/or valid email", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style:  UIAlertActionStyle.default)
        alert.addAction(okButton)
        
    }

}
