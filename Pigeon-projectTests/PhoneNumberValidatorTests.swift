//
//  PhoneNumberValidatorTests.swift
//  Pigeon-projectTests
//
//  Created by Shrikant Chidgopkar on 05/02/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import XCTest
@testable import Pigeon_project

class PhoneNumberValidatorTests: XCTestCase {
    
    let phoneNumberWithLessThanEightDigits = "831914"
    let phoneNumberWithEightDigits = "83191430"
    let phoneNumberWithGreaterThanEightDigits = "8319143090"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    // MARK: Phone Number length validation
    
    func testValidatePhoneNumberLessThanEightDigitsReturnsFalse(){
        
        let validator = PhoneNumberValidator()
        XCTAssertFalse(validator.validate(phoneNumberWithLessThanEightDigits), "Phone number less than eight digits should not be valid")
    }
    
    func testValidatePhoneNumberEqualToEightDigitsReturnsTrue(){
        
        let validator = PhoneNumberValidator()
        XCTAssertTrue(validator.validate(phoneNumberWithEightDigits), "Phone Number with Eight Digits should return true")
    }
    
    func testValidatePhoneNumberGreaterEightDigitsReturnsTrue(){
           
           let validator = PhoneNumberValidator()
           XCTAssertTrue(validator.validate(phoneNumberWithGreaterThanEightDigits), "Phone Number greater than Eight Digits should return true")
       }
       
    
    


}
