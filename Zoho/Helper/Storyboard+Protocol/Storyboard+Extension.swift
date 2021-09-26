//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import UIKit

extension UIViewController
{
    class var storyboardID : String
    {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
