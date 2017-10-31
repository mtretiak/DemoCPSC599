//
//  EndPoints.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import Foundation
import FirebaseDatabase
enum FIRDBDocs: String {
    case users, messages
}


enum EndPoints {
    case user, message
    
    var ref: DatabaseReference {
        switch self {
        case .user:
            return Database.database().reference().child(FIRDBDocs.users.rawValue)
        case .message:
            return Database.database().reference().child(FIRDBDocs.users.rawValue)
        }
    }
}



