//
//  phoneNumberValidator.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 04/02/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation

class PhoneNumberValidator: NSObject {
    
    func validate(_ value:String) -> Bool{
        
        if value.count < 8{
            return false
        }
        return true
    }
    
}
