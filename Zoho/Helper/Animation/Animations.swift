//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import UIKit

typealias SplashAnimatableCompletion = () -> Void

extension RevealingSplashView {
    
    func startAnimation(_ completion: SplashAnimatableCompletion? = nil)
    {
        playAnimation(completion)
    }
    
    func playAnimation(_ completion: SplashAnimatableCompletion? = nil)
    {
        
        if let imageView = self.imageView {
            
            let shrinkDuration: TimeInterval = duration * 0.3
            
          UIView.animate(withDuration: shrinkDuration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIView.AnimationOptions(), animations: {
                let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.75,y: 0.75)
                imageView.transform = scaleTransform
                }, completion: { finished in
                    self.playZoomOutAnimation(completion)
            })
        }
    }
    
    func playZoomOutAnimation(_ completion: SplashAnimatableCompletion? = nil)
    {
        if let imageView =  imageView
        {
            let growDuration: TimeInterval =  duration * 0.3
            
            UIView.animate(withDuration: growDuration, animations:{
                
                imageView.transform = self.getZoomOutTranform()
                self.alpha = 0
                
                }, completion: { finished in
                    
                    self.removeFromSuperview()                    
                    completion?()
            })
        }
    }
    
    
    fileprivate func getZoomOutTranform() -> CGAffineTransform
    {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
        return zoomOutTranform
    }
    
    
}
