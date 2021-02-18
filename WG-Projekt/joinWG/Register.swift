//
//  Register.swift
//  WG-Projekt
//
//  Created by Selin Bilge on 17.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class Register: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwortText: UITextField!
    
    @IBOutlet weak var Button: UIButton!
    
    @IBAction func Button(_ sender: Any) {
   
        
        if emailText.text != "" && nameText.text != "" && passwortText.text != "" && emailText.text?.isEmail == true {
            
            var created = false
            var userID = ""
            
            var alreadySignedIn = Auth.auth().currentUser?.email
            
            // check if user has already an account
            if alreadySignedIn != emailText.text {
                
                var username = nameText.text
                var useremail = emailText.text
                var userpassword = passwortText.text
                
                // create User
                FirebaseAuth.Auth.auth().createUser(withEmail: useremail!, password: userpassword!) { ( result, err)  in
                    
                    // check for errors
                    if err != nil {
                       self.showToast(message: "Error beim User erstellen", font: .systemFont(ofSize: 12.0))
                        print(err)
                        
                    } else {
                        created = true
                        print("Register -> User created account")
                        
                    }
                    
                    
                    if created == true {
                        
                        var  userID = Auth.auth().currentUser!.uid
                        print("Register -> Test UserID: \(userID)")

                        // save in firestore
                        let db = Firestore.firestore()
                        
                       
                        
                        // add a document with specific id -> is the user id
                        db.collection("users").document(userID).setData(["name":username, "wgname": "", "wgpasswort": "", "wgkey":""]) { (error) in
                            
                            if let error = error {
                                // error happened
                                self.showToast(message: "Error beim speichern in der Datenbank", font: .systemFont(ofSize: 12.0))
                            } else {
                                print("Register -> Saved in Firestore")
                                
                                // go to next screen
                                self.performSegue(withIdentifier: "joinWG", sender: nil)
                            }
                        }
                        
                    
                    }
                        
                }
                                  
                
            } else {
                self.showToast(message: "Du bist schon registriert", font: .systemFont(ofSize: 12.0))
            }
            
            
        } else {
            self.showToast(message: "Bitte fülle alle Felder aus", font: .systemFont(ofSize: 12.0))
        }
        
    }
    
    
}
