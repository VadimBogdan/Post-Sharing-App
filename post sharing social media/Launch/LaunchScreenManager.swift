//
//  LaunchScreenManager.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

final class LaunchScreenManager {
    
    static let instance = LaunchScreenManager()
    
    private lazy var view: UIView = {
        return loadLaunchView()
    }()
    private weak var parentView: UIView!
    
    private init() {}
    
    func animateAfterLaunch(_ parentView: UIView) {
        self.parentView = parentView
        fillParentViewWithLaunchView()
        
        startAnimation()
    }
    
    fileprivate func loadLaunchView() -> UIView {
        let nib = UINib(nibName: "LaunchScreen", bundle: Bundle.main)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    fileprivate func fillParentViewWithLaunchView() {
        parentView.addSubview(view)
        
        view.frame = parentView.bounds
        view.center = parentView.center
    }
    
    fileprivate func startAnimation() {
        guard let sendOvalView = view.viewWithTag(AnimatedPartsTags.sendOval),
              let sendView = view.viewWithTag(AnimatedPartsTags.send) else { return }
        
        let ovalFrame = sendOvalView.frame,
            sendFrame = sendView.frame
        
        sendOvalView.isHidden = true
        
        sendView.frame = sendFrame
                
        let animatedOval = UIView()
        view.addSubview(animatedOval)
        
        animatedOval.frame = ovalFrame
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: ovalFrame.size)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = 5
        shape.path = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 2.5, y: 2.5),
                                                      size: CGSize(width: ovalFrame.size.width-5,
                                                                   height: ovalFrame.size.height-5)),
                                  cornerRadius: 75).cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        
        let animationStrokeStart = CABasicAnimation(keyPath: "strokeStart")
        animationStrokeStart.fromValue = 0
        animationStrokeStart.toValue = 0.5
        
        let animationStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animationStrokeEnd.fromValue = 1
        animationStrokeEnd.toValue = 0.5
        
        let animationGroup = CAAnimationGroup()
        
        animationGroup.animations = [animationStrokeStart, animationStrokeEnd]
        animationGroup.duration = 1.75
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
                
        shape.add(animationGroup, forKey: "MyAnimation")
        
        UIView.animate(withDuration: 1.5, delay: 1.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: { self.view.alpha = 0 },
                       completion: { result in self.view.removeFromSuperview() })

        animatedOval.layer.addSublayer(gradient)
    }
}

struct AnimatedPartsTags {
    static let sendOval = 1
    static let send = 2
}
