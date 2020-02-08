//
//  EnterPhoneNumberProtocol.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 05/02/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation


protocol EnterPhoneNumberProtocol:class {
    
    
    func configurePhoneNumberContainerView()
    func dismissKeyboardAndController()
    func setCountry(countryCode:String, countryTitle:String)
    func setBackGroundColor()
    func configureNavigationBar()
    func enableRightBarButton(_ status:Bool)
    func displayErrorAlert(title:String, message:String)
}
