//
//  EnterPhoneNumberViewModelTests.swift
//  Pigeon-projectTests
//
//  Created by Shrikant Chidgopkar on 05/02/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import XCTest
@testable import Pigeon_project

class EnterPhoneNumberViewModelTests: XCTestCase {
    
    fileprivate var mockEnterPhoneNumberViewController:MockEnterPhoneNumberController?
    fileprivate var validPhoneNumber = "83191430"
    fileprivate var invalidPhoneNumber = "1234"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockEnterPhoneNumberViewController = MockEnterPhoneNumberController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformInitialViewSetup_DisablesRightBarButton_OnEnterPhoneNumberViewController(){
        
        let expectation = self.expectation(description: "expected enableRightBarButton(false) to be called")
        
        mockEnterPhoneNumberViewController?.expectationForEnableRightBarButton = (expectation, false)
        
        let viewModel = EnterPhoneNumberViewModel(view: mockEnterPhoneNumberViewController!)
        
        viewModel?.performInitialSetUp()
        
         self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    func testPhoneNumberUpdated_Calls_Validate_OnPhoneNumberValidator(){
        
        let expectation = self.expectation(description: "expected validate() to be called")
        
        let viewModel = EnterPhoneNumberViewModel(view: mockEnterPhoneNumberViewController!)

        viewModel?.phoneNumberValidator = MockPhoneNumberValidator(expectation, expectedValue: validPhoneNumber)
        
        viewModel?.phoneNumberUpdated(validPhoneNumber)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)

        
    }
    
    
    func testPhoneNumberUpdated_ValidPhoneNumber_EnablesRightBarButton_OnEnterPhoneNumberViewController(){
        
        let expectation = self.expectation(description: "expected enableRightBarButton(true) to be called")
        
        mockEnterPhoneNumberViewController?.expectationForEnableRightBarButton = (expectation, true)
        
        let viewModel = EnterPhoneNumberViewModel(view: mockEnterPhoneNumberViewController!)
        
        viewModel?.phoneNumberUpdated(validPhoneNumber)
        
        self.waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testPhoneNumberUpdated_InvalidPhoneNumber_DisablesRightBarButton_OnEnterPhoneNumberViewController(){
        
        let expectation = self.expectation(description: "expected enableRightBarButton(false) to be called")
            
            mockEnterPhoneNumberViewController?.expectationForEnableRightBarButton = (expectation, false)
            
            let viewModel = EnterPhoneNumberViewModel(view: mockEnterPhoneNumberViewController!)
            
            viewModel?.phoneNumberUpdated(invalidPhoneNumber)
            
            self.waitForExpectations(timeout: 1, handler: nil)
        
        
    }


}
