//
//  LoginViewController.swift
//  pset6
//
//  Created by Ayanna Colden on 08/12/2016.
//  Copyright © 2016 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailText.text = ""
        passwordText.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginUser(_ sender: Any) {
        
        // Check if login field is filled correctly.
        if emailText.text! == "" && passwordText.text == "" {
            self.alertError()
        }
        
        // Log in user.
        FIRAuth.auth()!.signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) {
            (user, error) in
            if error != nil {
                self.alertError()
            }
            
            self.performSegue(withIdentifier: "login", sender: self)
        }
    }
    
    func alertError() {
        let alert = UIAlertController(title: "Error logging in", message: "Enter valid email/password, if no login click on 'register' to create account", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
}

