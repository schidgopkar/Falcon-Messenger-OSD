//
//  EnterPhoneNumberController.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class EnterPhoneNumberController: UIViewController {
  
    var viewModel:EnterPhoneNumberViewModel?
    
    let phoneNumberContainerView = EnterPhoneNumberContainerView()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.viewModel == nil{
        self.viewModel = EnterPhoneNumberViewModel(view: self)
    }
    viewModel?.performInitialSetUp()
  }
    
  @objc func leftBarButtonDidTap() {
    viewModel?.leftBarButtonDidTap()
  }

    
  @objc func openCountryCodesList() {
    let picker = SelectCountryCodeController()
    picker.delegate = self
    phoneNumberContainerView.phoneNumber.resignFirstResponder()
    navigationController?.pushViewController(picker, animated: true)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if textField == phoneNumberContainerView.phoneNumber{
        viewModel?.phoneNumberUpdated(textField.text!)
    }
  }
  
  
  @objc func rightBarButtonDidTap () {
    
        let phoneNumberForVerification = phoneNumberContainerView.countryCode.text! + phoneNumberContainerView.phoneNumber.text!
    
    viewModel?.rightBarButtonDidTap(phoneNumberForVerification)
  }
  
}

extension EnterPhoneNumberController: CountryPickerDelegate {
  
  func countryPicker(_ picker: SelectCountryCodeController, didSelectCountryWithName name: String, code: String, dialCode: String) {
    phoneNumberContainerView.selectCountry.setTitle(name, for: .normal)
    phoneNumberContainerView.countryCode.text = dialCode
    picker.navigationController?.popViewController(animated: true)
  }
}

extension EnterPhoneNumberController:EnterPhoneNumberProtocol{
    
    
   @objc func configurePhoneNumberContainerView() {
      view.addSubview(phoneNumberContainerView)
      phoneNumberContainerView.frame = view.bounds
    }
    
    func dismissKeyboardAndController(){
        
        phoneNumberContainerView.phoneNumber.resignFirstResponder()
        self.dismiss(animated: true) {
          AppUtility.lockOrientation(.allButUpsideDown)
        }
                
    }
    
    func setCountry(countryCode:String, countryTitle:String) {
    
          phoneNumberContainerView.countryCode.text = countryCode
          phoneNumberContainerView.selectCountry.setTitle(countryTitle, for: .normal)
        
    }
    
    func setBackGroundColor(){
        
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor

    }
    
    func configureNavigationBar () {
      let rightBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(rightBarButtonDidTap))
      self.navigationItem.rightBarButtonItem = rightBarButton
      self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func enableRightBarButton(_ status:Bool){
        
        self.navigationItem.rightBarButtonItem?.isEnabled = status
    }
    
    func displayErrorAlert(title:String, message:String){
        basicErrorAlertWith(title: title, message: message, controller: self)
    }
    
    
}
