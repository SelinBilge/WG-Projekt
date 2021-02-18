//
//  Singelton.swift
//  WG-Projekt
//
//  Created by Selin Bilge on 17.02.21.
//  Copyright © 2021 WG-Projekt. All rights reserved.
//

import Foundation

class Singelton {
    
    static let sharedInstance = Singelton()

    var sharedUser = userObject()
    
    private init(){
    }
    
    func fetchdata() -> userObject{
        print("Username: \( sharedUser.userName)")
        print("Wgid: \( sharedUser.wgid)")
        for member in sharedUser.members {
            print("Collegues: \(member)")
        }
        
        return self.sharedUser
    }
    
}


class userObject {
    var userName = ""
    var members = [String]()
    var wgid = ""
}
