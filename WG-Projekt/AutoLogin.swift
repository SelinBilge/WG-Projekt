//
//  AutoLogin.swift
//  WG-Projekt
//
//  Created by Paul Pfisterer on 19.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AutoLogin: UIViewController {
    let db = Firestore.firestore()
    let userObject = Singelton.sharedInstance.fetchdata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if(Auth.auth().currentUser == nil) {
            performSegue(withIdentifier: "loginManualy", sender: nil)
        } else {
            let  userID = Auth.auth().currentUser!.uid
            db.collection("users").document(userID).getDocument { (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        let docData = document!.data()!
                        self.userObject.wgid = docData["wgkey"] as! String
                        self.userObject.userName = docData["name"] as! String
                        
                        if(self.userObject.wgid == "") {
                            self.performSegue(withIdentifier: "loginManualy", sender: nil)
                            return;
                        }
                        
                        self.db.collection("wgs").document(self.userObject.wgid).getDocument { (document, error) in
                            if error == nil {
                                if document != nil && document!.exists {
                                    let docData = document!.data()!
                                    self.userObject.members = docData["users"] as! [String]
                                    self.performSegue(withIdentifier: "loginAuto", sender: nil)
                                } else {
                                    self.performSegue(withIdentifier: "loginManualy", sender: nil)
                                }
                            } else {
                                self.performSegue(withIdentifier: "loginManualy", sender: nil)
                            }
                        }
                    } else {
                        self.performSegue(withIdentifier: "loginManualy", sender: nil)
                    }
                } else {
                    self.performSegue(withIdentifier: "loginManualy", sender: nil)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
