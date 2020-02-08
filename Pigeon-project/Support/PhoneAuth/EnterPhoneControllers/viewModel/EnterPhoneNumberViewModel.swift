//
//  EnterPhoneNumberViewModel.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 04/02/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import SafariServices
import Firebase



class EnterPhoneNumberViewModel: NSObject {
    
    weak var view:EnterPhoneNumberProtocol?
    
    var phoneNumberValidator:PhoneNumberValidator?
    var phoneNumberValidated:Bool
    
    
        let countries = Country().countries
    
    
    init?(view:EnterPhoneNumberProtocol){
        
        self.phoneNumberValidated = false
        
        super.init()
        
        self.view = view
        
    }
    
    func performInitialSetUp(){
        
        view?.configurePhoneNumberContainerView()
        view?.setBackGroundColor()
        view?.configureNavigationBar()
        view?.enableRightBarButton(false)
    }
    
    func setCountry(){
        
        for country in countries {
          if  country["code"] == countryCode {
            if let countryCode = country["dial_code"], let countryTitle = country["name"]{
                 view?.setCountry(countryCode: countryCode, countryTitle:countryTitle )
            }
          }
        }

        
    }
    
    
    func leftBarButtonDidTap(){
        view?.dismissKeyboardAndController()
    }
   
    
    func phoneNumberUpdated(_ value:String?){
        
        guard let value = value else{
            view?.enableRightBarButton(false)
            return
        }
        
        let phoneNumberValidator = self.phoneNumberValidator ?? PhoneNumberValidator()
        
        phoneNumberValidated = phoneNumberValidator.validate(value)
        if phoneNumberValidated == false{
            view?.enableRightBarButton(false)
            return
        }
        
        view?.enableRightBarButton(true)
        
    }
    
    var isVerificationSent = false

    
    func rightBarButtonDidTap(_ phoneNumber:String){
        
        if currentReachabilityStatus == .notReachable {
            view?.displayErrorAlert(title: "No internet connection", message: noInternetError)
          return
        }
        
        if !isVerificationSent {
            sendSMSConfirmation(phoneNumber)
        } else {
          print("verification has already been sent once")
        }
        
    }
    
    func sendSMSConfirmation (_ phoneNumber:String) {
      
      print("tappped sms confirmation")
      
      PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
        if let error = error {
            self.view?.displayErrorAlert(title: "Error", message: error.localizedDescription + "\nPlease try again later.")
          return
        }
        
        print("verification sent")
        self.isVerificationSent = true
        userDefaults.updateObject(for: userDefaults.authVerificationID, with: verificationID)
      }
    }

    
    
}
