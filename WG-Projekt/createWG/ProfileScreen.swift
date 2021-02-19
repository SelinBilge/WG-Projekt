//
//  ProfileScreen.swift
//  WG-Projekt
//
//  Created by Selin Bilge on 10.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

extension String {
          var isEmail: Bool {
             let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
             let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailTest.evaluate(with: self)
          }
}


class ProfileScreen: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func name(_ sender: Any) {
    }
    
    @IBAction func email(_ sender: Any) {
        
        if emailText.text != ""{
            
            // email is not valid
           if emailText.text!.isEmail == false {
               self.showToast(message: "Das ist keine Emailadresse", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    
    @IBAction func password(_ sender: Any) {
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
           
        let username = nameText.text!.trimmingCharacters(in: .newlines)
        let useremail = emailText.text!.trimmingCharacters(in: .newlines)
        let userpassword = passwordText.text!.trimmingCharacters(in: .newlines)
        
        if username != "" && useremail != "" && userpassword != "" && emailText.text?.isEmail == true {
        
            var created = false
            var userID = ""
            
            var alreadySignedIn = Auth.auth().currentUser?.email
            
            // check if user has already an account
            if alreadySignedIn != useremail {
                
                // create User
                FirebaseAuth.Auth.auth().createUser(withEmail: useremail, password: userpassword) { ( result, err)  in
                    
                    // check for errors
                    if err != nil {
                       self.showToast(message: "Error beim User erstellen", font: .systemFont(ofSize: 12.0))
                        print(err)
                        
                    } else {
                        created = true
                        print("ProfileScreen -> User created account")
                        
                        // save name in singelton
                        let testUser = Singelton.sharedInstance.fetchdata()
                        testUser.userName = self.nameText.text!
                    }
                                        
                    if created == true {
                        
                        var  userID = Auth.auth().currentUser!.uid
                        print("ProfileScreen -> Test UserID: \(userID)")

                        // save in firestore
                        let db = Firestore.firestore()
                        
                        // generate random Int number
                        let randomWgKey = Int.random(in: 100000000...999999999)

                        var key = String(randomWgKey)
                        print("ProfileScreen -> Test randomKey: \(key)")

                        
                        // add a document with specific id -> is the user id
                        db.collection("users").document(userID).setData(["name":username, "wgname": "", "wgpasswort": "", "wgkey":key]) { (error) in
                            
                            if let error = error {
                                // error happened
                                self.showToast(message: "Error beim speichern in der Datenbank", font: .systemFont(ofSize: 12.0))
                            } else {
                                print("ProfileScreen -> Saved in Firestore")
                                
                                // go to next screen
                                self.performSegue(withIdentifier: "AfterProfile", sender: nil)
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



extension UIViewController {

func showToast(message: String, font: UIFont) {
    let toastLabel = UILabel()
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = .white
    toastLabel.font = font
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds = true
    
    let maxWidthPercentage: CGFloat = 0.8
    let maxTitleSize = CGSize(width: view.bounds.size.width * maxWidthPercentage, height: view.bounds.size.height * maxWidthPercentage)
    var titleSize = toastLabel.sizeThatFits(maxTitleSize)
    titleSize.width += 20
    titleSize.height += 10
    toastLabel.frame = CGRect(x: view.frame.size.width / 2 - titleSize.width / 2, y: view.frame.size.height - 50, width: titleSize.width, height: titleSize.height)
    
    view.addSubview(toastLabel)
    
    UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: { _ in
        toastLabel.removeFromSuperview()
    })
    }
    
}
