//
//  MockEnterPhoneNumberLoginController.swift
//  Pigeon-projectTests
//
//  Created by Shrikant Chidgopkar on 31/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import XCTest
@testable import Pigeon_project

class MockEnterPhoneNumberController: EnterPhoneNumberProtocol {
    
    var expectationForEnableRightBarButton:(XCTestExpectation, Bool)?
    
    
    
    func configurePhoneNumberContainerView() {
        
    }
    
    func dismissKeyboardAndController() {
        
    }
    
    func setCountry(countryCode: String, countryTitle: String) {
        
    }
    
    func setBackGroundColor() {
        
    }
    
    func configureNavigationBar() {
        
    }
    
    func enableRightBarButton(_ status: Bool) {
        
        if let (expectation, expectedValue) = self.expectationForEnableRightBarButton {
            if status == expectedValue {
                expectation.fulfill()
            }else{
                expectation.isInverted = true
                expectation.fulfill()
            }
        }

        
    }
    
    func displayErrorAlert(title: String, message: String) {
        
    }
    
    
}
