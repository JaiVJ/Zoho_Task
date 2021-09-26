//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import UIKit

class RevealingSplashView: UIView, SplashAnimatable{
        
    var iconImage: UIImage? {
        didSet{
            if let iconImage = self.iconImage{
                imageView?.image = iconImage
            }
        }
    }
    
    var iconInitialSize: CGSize = CGSize(width: 60, height: 60) {
        didSet {
             imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        }
    }
    
    var backgroundImageView: UIImageView?
    
    var imageView: UIImageView?
        
    var duration: Double = 1.5
    
    var delay: Double = 0.5
    
    init(iconImage: UIImage, iconInitialSize:CGSize, backgroundImage: UIImage)
    {

        self.imageView = UIImageView()
        self.iconImage = iconImage
        self.iconInitialSize = iconInitialSize

        super.init(frame: (UIScreen.main.bounds))
        
        imageView?.image = iconImage

        imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)

        imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        imageView?.center = self.center
        

        self.backgroundImageView = UIImageView()
        backgroundImageView?.image = backgroundImage
        backgroundImageView?.frame = UIScreen.main.bounds
        backgroundImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(backgroundImageView!)
        
        self.addSubview(imageView!)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
