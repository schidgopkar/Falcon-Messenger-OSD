//
//  StatusVideoPlayerViewController.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 18/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class StatusVideoPlayerViewController: UIViewController {
    
    var progressView:UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .white
        return progressView
    }()
    
    var containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let avplayerViewController = AVPlayerViewController()
    
    var videoURL:URL?
    
    
    func setupViews(){
        
        self.view.backgroundColor = .black
        
        self.view.addSubview(containerView)
        self.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        
        avplayerViewController.showsPlaybackControls = false
        
        self.containerView.addSubview(avplayerViewController.view)
        
        avplayerViewController.view.frame = containerView.bounds
        
        self.prepareToPlay()
        
    }
    
    
    private var playerItemContext = 0
    
    func prepareToPlay() {
        let url = videoURL!
        // Create asset to be played
        let asset = AVAsset(url: url)
        
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        let  playerItem = AVPlayerItem(asset: asset,
                                       automaticallyLoadedAssetKeys: assetKeys)
        
        // Register as an observer of the player item's status property
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        
        // Associate the player item with the player
        avplayerViewController.player = AVPlayer(playerItem: playerItem)
        
        avplayerViewController.player?.play()
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                
                let seconds =  CMTimeGetSeconds((self.avplayerViewController.player?.currentItem!.duration)!)
                
                print("SECONDS ARE", seconds)
                
                UIView.animate(withDuration: seconds) {
                    self.progressView.setProgress(1.0, animated: true)
                    self.progressView.layoutIfNeeded()
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                    self.dismiss(animated: true, completion: nil)
                }
                
            // Player item is ready to play.
            case .failed: break
            // Player item failed. See error.
            case .unknown: break
            // Player item is not yet ready.
            @unknown default:
                break
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
    }
    
}
