//
//  File.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import UIKit

enum GiloryFontBook: String
{
    case Regular = "Gilroy-Regular"
    case Light = "Gilroy-Light"
    case Medium = "Gilroy-Medium"
    case Heavy = "Gilroy-Heavy"
    case Bold = "Gilroy-Bold"
}

extension UIFont
{
    class func appGiloryLightFontWith( size:CGFloat ) -> UIFont
    {
        return  UIFont(name: GiloryFontBook.Light.rawValue, size: size)!
    }
    
    class func appGiloryRegularFontWith( size:CGFloat ) -> UIFont
    {
        return  UIFont(name: GiloryFontBook.Regular.rawValue, size: size)!
    }
    
    class func appGiloryMediumFontWith( size:CGFloat ) -> UIFont
    {
        return  UIFont(name: GiloryFontBook.Medium.rawValue, size: size)!
    }
    
    class func appGiloryHeavyFontWith( size:CGFloat ) -> UIFont
    {
        return  UIFont(name: GiloryFontBook.Heavy.rawValue, size: size)!
    }

    class func appGiloryBoldFontWith( size:CGFloat ) -> UIFont
    {
        return  UIFont(name: GiloryFontBook.Bold.rawValue, size: size)!
    }
}

