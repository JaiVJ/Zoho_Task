//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import UIKit

enum AppStoryboard : String
{
    case Main
    
    var instance: UIStoryboard
    {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T
    {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else
        {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }
        
        return scene
    }
    
}

