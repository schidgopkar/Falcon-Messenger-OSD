//
//  BaseMessageCell.swift
//  Pigeon-project
//
//  Created by Roman Mizin on 8/8/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class BaseMessageCell: RevealableCollectionViewCell {
    
    weak var message: Message?
    weak var chatLogController: ChatLogController?
    
    let grayBubbleImage = ThemeManager.currentTheme().incomingBubble
    let blueBubbleImage = ThemeManager.currentTheme().outgoingBubble
    static let selectedOutgoingBubble = UIImage(named: "OutgoingSelected")!.resizableImage(withCapInsets: UIEdgeInsets(top: 14,
                                                                                                                       left: 14,
                                                                                                                       bottom: 17,
                                                                                                                       right: 28))
    static let selectedIncomingBubble = UIImage(named: "IncomingSelected")!.resizableImage(withCapInsets: UIEdgeInsets(top: 14,
                                                                                                                       left: 22,
                                                                                                                       bottom: 17,
                                                                                                                       right: 20))
    
    static let incomingTextViewTopInset: CGFloat = 10
    static let incomingTextViewBottomInset: CGFloat = 10
    static let incomingTextViewLeftInset: CGFloat = 12
    static let incomingTextViewRightInset: CGFloat = 7
    
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
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.numberOfLines = 1
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = FalconPalette.defaultBlue
        
        return nameLabel
    }()
    
    let messageSelfDestructionCountdownLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        label.textColor = FalconPalette.dismissRed
        label.textAlignment = .left
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame.integral)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDeliveryStatus(at indexPath: IndexPath, lastMessageIndex: Int, message: Message) {
        switch indexPath.row == lastMessageIndex {
        case true:
            DispatchQueue.main.async {
                self.deliveryStatus.frame = CGRect(x: self.frame.width - 80, y: self.bubbleView.frame.height + 2, width: 70, height: 10).integral
                self.deliveryStatus.text = message.status
                self.deliveryStatus.isHidden = false
                self.deliveryStatus.layoutIfNeeded()
            }
            break
            
        default:
            DispatchQueue.main.async {
                self.deliveryStatus.isHidden = true
                self.deliveryStatus.layoutIfNeeded()
            }
            break
        }
    }
    
    var timer:Timer?
    
    var count:Int?
    
    func setupMessageSelfDestructCountdown(){
        
        DispatchQueue.main.async {
            self.messageSelfDestructionCountdownLabel.frame = CGRect(x: self.bubbleView.frame.minX + 5, y: self.bubbleView.frame.height + 2, width: 200, height: 10).integral
            self.messageSelfDestructionCountdownLabel.isHidden = false
            self.messageSelfDestructionCountdownLabel.layoutIfNeeded()
        }
        
        self.configureCircleLayer()
        self.startCircleAnimation()
        
        count = 10
        
          timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
   
    }
    
    
    private var circleLayer = CAShapeLayer()

    private func configureCircleLayer() {
        let radius = min(self.contentView.bounds.width, self.contentView.bounds.height) / 2

        circleLayer.strokeColor = FalconPalette.dismissRed.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = radius
        self.contentView.layer.addSublayer(circleLayer)

        let center = CGPoint(x: self.contentView.bounds.width - radius - 5, y: self.contentView.bounds.height/2)
        let startAngle: CGFloat = -0.25 * 2 * .pi
        let endAngle: CGFloat = startAngle + 2 * .pi
        circleLayer.path = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath

        circleLayer.strokeEnd = 0
    }

    private func startCircleAnimation() {
        circleLayer.strokeEnd = 1
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 10
        circleLayer.add(animation, forKey: nil)
    }
    
  
    
    @objc func update() {
        if(count! > 0) {
            count = count! - 1
            messageSelfDestructionCountdownLabel.text = "Self Destruct in " + String(count!) + " seconds"
        }else{
            timer?.invalidate()
            DispatchQueue.main.async {
                self.circleLayer.removeFromSuperlayer()
                self.messageSelfDestructionCountdownLabel.isHidden = true
                self.messageSelfDestructionCountdownLabel.layoutIfNeeded()
            }
        }
    }
    
    func setupTimestampView(message: Message, isOutgoing: Bool) {
        DispatchQueue.main.async {
            let view = self.chatLogController?.collectionView?.dequeueReusableRevealableView(withIdentifier: "timestamp") as? TimestampView ?? TimestampView()
            view.titleLabel.text = message.convertedTimestamp
            let style: RevealStyle = isOutgoing ? .slide : .over
            self.setRevealableView(view, style: style, direction: .left)
        }
    }
    
    func setupViews() {
        backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        contentView.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
    }
    
    func prepareViewsForReuse() {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareViewsForReuse()
        deliveryStatus.text = ""
    }
}


extension CALayer {

func animateBorderColor(from startColor: UIColor, to endColor: UIColor, withDuration duration: Double) {
    let colorAnimation = CABasicAnimation(keyPath: "borderColor")
    colorAnimation.fromValue = startColor.cgColor
    colorAnimation.toValue = endColor.cgColor
    colorAnimation.duration = duration
    self.borderColor = endColor.cgColor
    self.add(colorAnimation, forKey: "borderColor")
}

}
