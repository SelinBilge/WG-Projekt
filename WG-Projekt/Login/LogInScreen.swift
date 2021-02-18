//
//  LogInScreen.swift
//  WG-Projekt
//
//  Created by Selin Bilge on 12.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInScreen: UIViewController {

    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var newEmailText: UITextField!
    
    @IBAction func email(_ sender: Any) {
        if newEmailText.text != ""{
            
            // email is not valid
           if newEmailText.text!.isEmail == false {
                
                // SHOW TOAST MESSAGE
                self.showToast(message: "Das ist keine Emailadresse", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let email = newEmailText.text!.trimmingCharacters(in: .newlines)
        let password = passwordText.text!.trimmingCharacters(in: .newlines)
    
        
        // check if fields are empty
        if email != "" && password != "" && newEmailText.text?.isEmail == true {
            
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
           
            // couldn't sign in
            if error != nil{
                self.showToast(message: error!.localizedDescription, font: .systemFont(ofSize: 12.0))
                
            } else {
                print("Login was successful")
                
                // get the wgkey for specific user
                let db = Firestore.firestore()
                let  userID = Auth.auth().currentUser!.uid
                
                var wgkey = ""
                var name = ""
                var users = [String]()

                
                // read data from specific document ID
                db.collection("users").document(userID).getDocument { (document, error) in
               
                    if error == nil {
                        // check if document exists
                        if document != nil && document!.exists {
                                                
                            let docData = document!.data()
                            wgkey = docData!["wgkey"] as? String ?? ""
                            print("Test get wgkey: \(wgkey)")
                            
                            name = docData!["name"] as? String ?? ""
                            print("Test get name: \(name)")
                            
                            // save name in singelton
                            let testUser = Singelton.sharedInstance.fetchdata()
                            testUser.userName = name
                            
                            // save wgid in singelton
                            testUser.wgid = wgkey
                            
                            
                            // read data from specific document ID
                            db.collection("wgs").document(wgkey).getDocument { (document, error) in
                           
                                if error == nil {
                                    // check if document exists
                                    if document != nil && document!.exists {
                                                            
                                        let docData = document!.data()
                                        
                                        
                                        // STIMMT SO DER ZUGRIFF AUF DAS ARRAY????
                                        // TESTEN MIT MEHREREN MITGLIEDERN
                                        users = (docData!["users"] as? [String])!
                                        print("Test get other users: \(users)")
                                        
                                        // save other wg members in singelton
                                        let testUser = Singelton.sharedInstance.fetchdata()
                                        
                                        users.forEach { user in
                                            testUser.members.append(user)
                                        }
                                        
                                        print("------------------------")
                                        Singelton.sharedInstance.fetchdata()
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                }
                          
                // go to next screen
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        }
        }
    }
    
    
}
