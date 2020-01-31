//
//  StatusImageDisplayViewControler.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 18/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit

class StatusImageDisplayViewControler: UIViewController {
    
    var statusImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    var progressView:UIProgressView = {
       let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .white
        return progressView
    }()
    
    var imageReference:String = ""
    
    func setUpViews(){
        
        self.view.addSubview(statusImageView)
        statusImageView.addSubview(progressView)
    
        NSLayoutConstraint.activate([
        
            statusImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            statusImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            statusImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            
            progressView.topAnchor.constraint(equalTo: statusImageView.topAnchor, constant: 10),
            progressView.centerXAnchor.constraint(equalTo: statusImageView.centerXAnchor),
            progressView.widthAnchor.constraint(equalTo: statusImageView.widthAnchor, constant: -20)
        
        ])
        
    }
    
    func setImage(){
        
            guard let imageReferenceURL = URL(string: imageReference) else {return}
        
            statusImageView.sd_setImage(with: imageReferenceURL) { (image, error, cache, url) in
                if let error = error{
                    print(error)
                }
                UIView.animate(withDuration: 4.0) {
                                  self.progressView.setProgress(1.0, animated: true)
                                  self.progressView.layoutIfNeeded()
                                   }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
                              self.dismiss(animated: true, completion: nil)
                          }
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.setUpViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.setImage()
        
    }
    
    
    
}
