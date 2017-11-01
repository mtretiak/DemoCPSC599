//
//  Message.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import Foundation

struct Message {
    let from: String // email of the message owner
    let username: String
    let body: String
    let date: Date
}

extension Message {
    
    init?(dict: [String: Any]) {
        guard let from = dict.string(key: "from"),
            let username = dict.string(key: "username"),
            let body = dict.string(key: "body"),
            let dateInterval = dict.double(key: "date") else { return nil }
        
        self.from = from
        self.username = username
        self.body = body
        self.date = Date(timeIntervalSince1970: dateInterval)
    }
    
    var json: [String:Any] {
        return [
            "from": from,
            "body": body,
            "username": username,
            "date": date.timeIntervalSince1970
        ]
    }
}


extension Message {
    
    static var messages: [Message]  {
        get {
            return [
               
                /*
                Message(from: DemoUser.userOne.username, body: "Hello guys", date: Date(timeInterval: 10, since: Date())),
                Message(from: DemoUser.userOne.username, body: "I was wondering if you will be avialable to meet this weekend", date: Date(timeInterval: 20, since: Date())),
                
                Message(from: DemoUser.userTwo.username, body: "I can, I am available all sunday", date: Date(timeInterval: 30, since: Date())),
                
                Message(from: DemoUser.userThree.username, body: "Me too.", date: Date(timeInterval: 60, since: Date())),
            
                Message(from: DemoUser.userOne.username, body: "Perfect then.", date: Date(timeInterval: 100, since: Date())),
            
                Message(from: DemoUser.userThree.username, body: "Where do u think we should meet. I know a good place on the computer science labs", date: Date(timeInterval: 200, since: Date())),
            
                Message(from: DemoUser.userOne.username, body: "Let's meet there then.", date: Date(timeInterval: 300, since: Date())),
            
                Message(from: DemoUser.userTwo.username, body: "Ok", date: Date(timeInterval: 350, since: Date())),
            
                Message(from: DemoUser.userThree.username, body: "See u there", date: Date(timeInterval: 400, since: Date())),
               */
            ]
        }
    }
    
    
    
    
}
