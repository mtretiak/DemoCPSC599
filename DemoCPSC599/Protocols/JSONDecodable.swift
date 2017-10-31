//
//  JSONDecodable.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias JSONDict = [String: Any]
protocol JSONDecodable {
    
    init?(json: JSONDict)
    init?(snapshot: DataSnapshot)
    func convertToJson() -> JSONDict
}


extension JSONDecodable {
    
    func convertToJson() -> JSONDict {
        return [:]
    }
}

extension JSONDecodable where Self: FirebaseIded {
    
    init?(snapshot: DataSnapshot) {
        guard let json = snapshot.value => JSONDict.self else { return nil }
        self.init(json: json)
        self.key = snapshot.key
    }
    
}


protocol FirebaseIded {
    var key: String { get set }
}
