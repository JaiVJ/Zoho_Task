//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import UIKit

public protocol SplashAnimatable: AnyObject {
    
    var imageView: UIImageView? { get set }
        
    var duration: Double { get set }
    
    var delay: Double { get set }
    
}
