//
//  User.swift
//  Snapchat
//
//  Created by Rethink on 28/03/22.
//

import Foundation

class User {
    var name : String
    var email : String
    var uid : String
    
    init(name: String , email : String , uid : String ){
        self.name = name
        self.email = email
        self.uid = uid
    }
    
}
