//
//  Marmita.swift
//  MarmiCop
//
//  Created by Alisson Selistre on 10/11/18.
//  Copyright © 2018 Alisson Selistre. All rights reserved.
//

import Foundation
import Firebase

struct Marmita {

    var armada: Bool = false
    var gemido: String = ""
    var userId: String = ""
    
    init?(dict: [String: Any]?) {
        guard
            let dict = dict,
            let armada = dict["armada"] as? Bool,
            let gemido = dict["gemido"] as? String,
            let userId = dict["userId"] as? String else {
                return nil
        }
        
        self.armada = armada
        self.gemido = gemido
        self.userId = userId
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "armada": armada,
            "gemido": gemido,
            "userId": userId
        ]
    }
}
