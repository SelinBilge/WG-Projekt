//
//  CreateWG.swift
//  WG-Projekt
//
//  Created by Selin Bilge on 13.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class CreateWG: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet weak var nameofWg: UITextField!
    @IBOutlet weak var passworttext: UITextField!
    
    @IBAction func wgname(_ sender: Any) {
    }
    
   
    @IBAction func password(_ sender: Any) {
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        
        if nameofWg.text != "" && passworttext.text != ""  {
            
            // create User
            let wgname =  nameofWg.text!.trimmingCharacters(in: .newlines)
            let wgpassword = passworttext.text!.trimmingCharacters(in: .newlines)
            
          
            // save WG Information
            let db = Firestore.firestore()
            let  userID = Auth.auth().currentUser!.uid
            print("CreateWG -> Test UserID: \(userID)")

            
            // updating a specific document id
            db.collection("users").document(userID).updateData(["wgname":wgname, "wgpasswort":wgpassword]) { (error) in
                
                if let error = error{
                    print("CreateWG -> \(error.localizedDescription)")
                    
                } else {
                    print("Updated Data")
                }
                
            }
            

            var wgkey = ""
            var username = ""
            
            // get the wgkey from user
            // read data from specific document ID
            db.collection("users").document(userID).getDocument { (document, error) in
           
                if error == nil {
                    // check if document exists
                    if document != nil && document!.exists {
                                            
                        let docData = document!.data()
                        wgkey = docData!["wgkey"] as? String ?? ""
                        print("CreateWG -> Test get code: \(wgkey)")
                        
                        username = docData!["name"] as? String ?? ""
                        print("CreateWG -> Test get username: \(username)")
                
                        
                        // add a document with specific id -> is the wgkey
                        db.collection("wgs").document(wgkey).setData(["wgname":wgname, "wgpasswort":wgpassword, "userkey":["0":userID], "users":["0":username]]) { (error) in
                            
                            if let error = error {
                                // error happened
                                self.showToast(message: "Error beim speichern in der Datenbank", font: .systemFont(ofSize: 12.0))
                            } else {
                                print("CreateWG -> userid and name saved in Firestore")
                                print("CreateWG -> finished saving data")

                                // go to next screen
                                self.performSegue(withIdentifier: "shareWG", sender: nil)
                            }
                            
                        }
                        
                        
                    }
                }
            }
 
           
            
        
           } else {
                // SHOW TOAST MESSAGE
                self.showToast(message: "Bitte fülle alle Felder aus", font: .systemFont(ofSize: 12.0))
           }
    }
    
    
}
