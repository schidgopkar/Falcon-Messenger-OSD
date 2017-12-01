//
//  BaseMessageCell.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/8/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class BaseMessageCell: RevealableCollectionViewCell {
  
  let grayBubbleImage = ThemeManager.currentTheme().incomingBubble
  let blueBubbleImage = ThemeManager.currentTheme().outgoingBubble
  
  let bubbleView: UIImageView = {
    let bubbleView = UIImageView()
    bubbleView.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
    bubbleView.isUserInteractionEnabled = true
    
    return bubbleView
  }()
  
  var deliveryStatus: UILabel = {
    var deliveryStatus = UILabel()
    deliveryStatus.text = "status"
    deliveryStatus.font = UIFont.boldSystemFont(ofSize: 10)
    deliveryStatus.textColor =  ThemeManager.currentTheme().generalSubtitleColor
    deliveryStatus.isHidden = true
    deliveryStatus.textAlignment = .right
    
    return deliveryStatus
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame.integral)
    
    setupViews()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setupViews() {
    backgroundColor =  ThemeManager.currentTheme().generalBackgroundColor
    contentView.backgroundColor =  ThemeManager.currentTheme().generalBackgroundColor
  }
  
  
  func prepareViewsForReuse() {}
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepareViewsForReuse()
  }
}
