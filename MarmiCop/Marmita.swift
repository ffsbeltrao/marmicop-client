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
    var gemendo: Bool = false
    
    init?(dict: [String: Any]?) {
        guard
            let dict = dict,
            let armada = dict["armada"] as? Bool,
            let gemido = dict["gemido"] as? String,
            let gemendo = dict["gemendo"] as? Bool else {
                return nil
        }
        
        self.armada = armada
        self.gemido = gemido
        self.gemendo = gemendo
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "armada": armada,
            "gemido": gemido,
            "gemendo": gemendo
        ]
    }
}
