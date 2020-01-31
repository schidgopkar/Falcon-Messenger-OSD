//
//  VoiceChatController.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 12/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit
import AgoraAudioKit


class VoiceChatController: UIViewController {
    
    let AppID: String = "9e3600871e5c43c1b84b2cd9dd21ecf6"
    
    let Token: String? = nil
    
    var agoraKit: AgoraRtcEngineKit!
    
    var topContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = FalconPalette.defaultBlue
        return view
    }()
    
    var headingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Falcon Voice Chat"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var partnerNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var bottomContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = FalconPalette.defaultBlue
        return view
    }()
    
    var muteChatButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "muteVChat"), for: .normal)
        button.setImage(UIImage(named: "muteSelected"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var endVoiceChatButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "endVChat"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var speakerButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "speaker"), for: .normal)
        button.setImage(UIImage(named: "speakerSelected"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var voiceChatImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "voiceChatImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setUpViews(){
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(topContainerView)
        topContainerView.addSubview(headingLabel)
        topContainerView.addSubview(partnerNameLabel)
        
        self.view.addSubview(bottomContainerView)
        
        self.view.addSubview(voiceChatImageView)
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            topContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: 150),
            
            headingLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            headingLabel.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor, constant: -20),
            headingLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            headingLabel.heightAnchor.constraint(equalToConstant: 30),
            
            partnerNameLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            partnerNameLabel.centerXAnchor.constraint(equalTo: headingLabel.centerXAnchor),
            partnerNameLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            partnerNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            bottomContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            
            muteChatButton.widthAnchor.constraint(equalToConstant: 70),
            muteChatButton.heightAnchor.constraint(equalToConstant: 70),
            
            endVoiceChatButton.widthAnchor.constraint(equalToConstant: 70),
            endVoiceChatButton.heightAnchor.constraint(equalToConstant: 70),
            
            speakerButton.widthAnchor.constraint(equalToConstant: 70),
            speakerButton.heightAnchor.constraint(equalToConstant: 70)
            
        ])
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10
        
        stackView.addArrangedSubview(muteChatButton)
        stackView.addArrangedSubview(endVoiceChatButton)
        stackView.addArrangedSubview(speakerButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            
            voiceChatImageView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            voiceChatImageView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            voiceChatImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            voiceChatImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        
        muteChatButton.addTarget(self, action: #selector(toggleMuteChatButton), for: .touchDown)
        speakerButton.addTarget(self, action: #selector(toggleSpeakerButton), for: .touchDown)
        endVoiceChatButton.addTarget(self, action: #selector(endVoiceChatButtonPressed), for: .touchUpInside)
        
    }
    
    
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: nil)
    }
    
    func joinChannel() {
        agoraKit.joinChannel(byToken: Token, channelId: "demoChannel", info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
            self.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    
    @objc func toggleMuteChatButton(){
        muteChatButton.isSelected = !muteChatButton.isSelected
        agoraKit.muteLocalAudioStream(muteChatButton.isSelected)
    }
    
    @objc func toggleSpeakerButton(){
        speakerButton.isSelected = !speakerButton.isSelected
        agoraKit.setEnableSpeakerphone(speakerButton.isSelected)
    }
    
    @objc func endVoiceChatButtonPressed(){
        leaveChannel()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        initializeAgoraEngine()
        joinChannel()
    }
    
    
    
    
    
    
}
