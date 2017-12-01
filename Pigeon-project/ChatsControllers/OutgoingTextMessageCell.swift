//
//  OutgoingTextMessageCell.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/8/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


class OutgoingTextMessageCell: BaseMessageCell {
  
  let textView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 13)
    textView.backgroundColor = .clear
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7)
    textView.dataDetectorTypes = .all
    textView.textColor = .white
    textView.linkTextAttributes = [NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
  
    return textView
  }()
  
  override func setupViews() {
    
    contentView.addSubview(bubbleView)
    bubbleView.addSubview(textView)
    contentView.addSubview(deliveryStatus)
    bubbleView.image = blueBubbleImage
  }
}
