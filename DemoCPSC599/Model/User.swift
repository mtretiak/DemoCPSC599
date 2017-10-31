//
//  User.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import Foundation


struct DemoUser {
    var uid: String
    var email: String
    var username: String
    
    
    
    static var userOne: DemoUser = {
        return DemoUser(uid: "id", email: "email1@email.com", username: "usernameone")
    }()
    
    static var userTwo: DemoUser = {
        return DemoUser(uid: "id", email: "email2@email.com", username: "usernametwo")
    }()
    
    static var userThree: DemoUser = {
        return DemoUser(uid: "id", email: "email3@email.com", username: "usernamethree")
    }()
}

