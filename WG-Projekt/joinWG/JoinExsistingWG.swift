//
//  JoinExsistingWG.swift
//  WG-Projekt
//
//  Created by Selin Bilge on 17.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class JoinExsistingWG: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBOutlet weak var wgNametext: UITextField!
    @IBOutlet weak var wgPasswordText: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
   
        if wgNametext.text != "" && wgPasswordText.text != "" {
            
            let  userID = Auth.auth().currentUser!.uid
            let db = Firestore.firestore()
       
            var username = ""
            var wgkey = ""
            var wgname = ""
            var wgpasswort = ""
            
            // read data from specific document ID
            db.collection("users").document(userID).getDocument { (document, error) in
           
                if error == nil {
                    // check if document exists
                    if document != nil && document!.exists {
                                            
                        let docData = document!.data()
                        wgkey = docData!["wgkey"] as? String ?? ""
                        print("JoinExsistingWG -> Test get code: \(wgkey)")
                        
                        username = docData!["name"] as? String ?? ""
                        print("JoinExsistingWG -> Test get username: \(username)")
                        
                        wgname = docData!["wgname"] as? String ?? ""
                        print("JoinExsistingWG -> Test get wgname: \(wgname)")
                        
                        wgpasswort = docData!["wgpasswort"] as? String ?? ""
                        print("JoinExsistingWG -> Test get wgpasswort: \(wgpasswort)")
                
                        
                        // save name in singelton
                        let testUser = Singelton.sharedInstance.fetchdata()
                        testUser.userName = username
        
                        
                        
                        // check if user is already in an wg
                        if wgname == "" {
                            
                            var documentID = ""
                            
                            print("CHECK: \(self.wgNametext.text!)")
                            
                            // search given wg in database
                            db.collection("wgs").whereField("wgname", isEqualTo: self.wgNametext.text!).getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        print("\(document.documentID) => \(document.data())")
                                        
                                    
                                        
                                        // get document id
                                        documentID = document.documentID
                                        print("Teeeest: \(documentID)")

                                        
                                        // add user in the wg document
                                        if documentID != "" {
                                            
                                            var users = [String]()
                                            var userids = [String]()
                                            
                                            // save name in singelton
                                            let testUser = Singelton.sharedInstance.fetchdata()
                                            testUser.wgid = documentID
                                            
                                            
                                            
                                            // get other wg members
                                            // read data from specific document ID
                                            db.collection("wgs").document(documentID).getDocument { (document, error) in
                                           
                                                if error == nil {
                                                    // check if document exists
                                                    if document != nil && document!.exists {
                                                                            
                                                        let docData = document!.data()
                                                        users = (docData!["users"] as? [String])!
                                                        print("JoinExsistingWG -> Test get users: \(users)")
                                                        
                                                        userids = (docData!["userkey"] as? [String])! 
                                                        print("JoinExsistingWG -> Test get userskeys: \(userids)")
                                                        
                                                
                                                        // save other wg members in singelton
                                                        let testUser = Singelton.sharedInstance.fetchdata()
                                                        
                                                        users.forEach { user in
                                                            testUser.members.append(user)
                                                        }
                                                        
                                                    }
                                                }
                                            }
 
                                            
                                            
                                            // add user in wg document with id
                                            // Atomically add a new region to the "users" and "userkey" array field.
                                            db.collection("wgs").document(documentID).updateData([
                                             "userkey": FieldValue.arrayUnion([userID]),
                                             "users": FieldValue.arrayUnion([username]) ]) { (error) in
                                                
                                                if let error = error {
                                                    print("JoinExsistingWG -> \(error.localizedDescription)")
                                                } else {
                                                    print("User added to array in wg")
                                                }
                                                
                                            }

                                             // update user
                                             // updating a specific document id
                                             db.collection("users").document(userID).updateData(["wgname":self.wgNametext.text!, "wgpasswort":self.wgPasswordText.text!, "wgkey": documentID]) { (error) in
                                                 
                                                 if let error = error{
                                                     print("JoinExsistingWG -> \(error.localizedDescription)")
                                                     
                                                 } else {
                                                    print("Updated Data")
                                                    print("------------------------")
                                                    Singelton.sharedInstance.fetchdata()
                                                   
                                                    
                                                    // go to next screen
                                                    self.performSegue(withIdentifier: "Home", sender: nil)
                                                 }
                                             }
                                            
                                        } else {
                                            self.showToast(message: "Diese WG existiert nicht", font: .systemFont(ofSize: 12.0))
                                        }
                                        
                                    }
                                }
                            }
                            
                            
                        } else {
                            self.showToast(message: "Du kannst nicht mehreren WGs beitreten", font: .systemFont(ofSize: 12.0))
                        }
                        
                    }
                }
            }
            
            
            
        } else {
            self.showToast(message: "Bitte fülle alle Felder aus", font: .systemFont(ofSize: 12.0))
        }
    
    }
    
    
}
