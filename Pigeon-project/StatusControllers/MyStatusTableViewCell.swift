//
//  MyStatusTableViewCell.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 15/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit


class MyStatusTableViewCell: UITableViewCell {
    
    var statusImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "statusImage")
        return imageView
    }()
    
    var addStatusImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "addStatus")
        return imageView
    }()
    
    var myStatusLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Status"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
     var addStatusLabel:UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "Tap to add status"
           label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
           return label
       }()
    
    
    
    func setupViews(){
        
        self.contentView.addSubview(statusImageView)
        self.contentView.addSubview(addStatusImageView)
        self.contentView.addSubview(myStatusLabel)
        self.contentView.addSubview(addStatusLabel)
        
        NSLayoutConstraint.activate([
        
            statusImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30),
            statusImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 80),
            statusImageView.heightAnchor.constraint(equalToConstant: 80),
            
            addStatusImageView.centerXAnchor.constraint(equalTo: statusImageView.rightAnchor, constant: -10),
            addStatusImageView.bottomAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: -10),
            addStatusImageView.widthAnchor.constraint(equalToConstant: 20),
            addStatusImageView.heightAnchor.constraint(equalToConstant: 20),
            
            myStatusLabel.topAnchor.constraint(equalTo: statusImageView.topAnchor),
            myStatusLabel.leftAnchor.constraint(equalTo: statusImageView.rightAnchor, constant: 15),
            myStatusLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            myStatusLabel.heightAnchor.constraint(equalTo: statusImageView.heightAnchor, multiplier: 0.5, constant: 0),
            
            addStatusLabel.leftAnchor.constraint(equalTo: myStatusLabel.leftAnchor),
            addStatusLabel.rightAnchor.constraint(equalTo: myStatusLabel.rightAnchor),
            addStatusLabel.topAnchor.constraint(equalTo: myStatusLabel.bottomAnchor),
            addStatusLabel.bottomAnchor.constraint(equalTo: statusImageView.bottomAnchor)
            
        ])
        
        
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
