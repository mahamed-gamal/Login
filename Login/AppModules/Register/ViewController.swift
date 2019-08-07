//
//  ViewController.swift
//  Login
//
//  Created by Mohamed Gamal on 8/7/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    enum topSegment: Int {        //enum to segment control
        case login
        case register
    }
    
    var currentPage: topSegment = .login      // to determine the current page

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
             submitButton.setTitle("login", for: .normal)
        }
    }
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!{
        didSet{
            userNameField.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userNameField.text = ""
        emailField.text = ""
        passwordField.text = ""
        if(Auth.auth().currentUser != nil){     //present to home if not log out
            presentHome()
    }
}
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func presentHome() {      // method to present to home page
        let view = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") 
        self.present(view!, animated: true, completion: nil)
    }
    
    func displayError(errorText: String){     // alert view when error occured
        let alert = UIAlertController.init(title: "Error", message: errorText, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if let selectedSegment = topSegment(rawValue: segmentControl.selectedSegmentIndex){
            switch selectedSegment {
            case .login:
                userNameField.isHidden = true
                submitButton.setTitle("login", for: .normal)
                currentPage = .login
            case .register:
                userNameField.isHidden = false
                submitButton.setTitle("Register", for: .normal)
                currentPage = .register
                
            }
        }
    }
    @IBAction func didPressedOnSubmit(_ sender: Any) {
        guard let email = emailField.text , let password = passwordField.text else{
            return
        }
        switch currentPage {
            
        case .login:
            if(emailField.text?.isEmpty == true || passwordField.text?.isEmpty == true ){
                displayError(errorText: "please fill empty fields.")
                
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if(error == nil){
                        self.presentHome()
                    } else {
                        self.displayError(errorText: "wrong userName or password")
                    }
                }
            }
            
            
        case .register:
            if(emailField.text?.isEmpty == true || passwordField.text?.isEmpty == true || userNameField.text?.isEmpty == true){
                displayError(errorText: "please fill empty fields.")
                
            } else {
                
                guard let userName = userNameField.text else {
                    return
                }
                let data: [String: String] = ["username": userName , "password" : password , "email" : email]
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if(error == nil){
                        let db = Database.database().reference()
                        db.child("users").child(result!.user.uid).setValue(data)
                        self.presentHome()
                        
                    } else {
                        
                        self.displayError(errorText: "wrong userName or password")
                    }
                }
            }
            
        }
        
    }
    
}

