//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import Alamofire
import SDWebImage
import CoreLocation

class Connectivity
{
    class func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}


class ImageLoader
{
    func imageLoad(imgView :UIImageView,url :String,placeholder :String = "user_placeholder")
    {
        imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: placeholder))
    }
}

@IBDesignable open class CustomView: UIView {
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.backgroundColor!)
        }
        set {
            self.layer.backgroundColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
}

class LocationManager
{
    class func isLocationEnabled() ->Bool
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
            @unknown default:
                fatalError()
            }
        }
        else
        {
            print("Location services are not enabled")
            return false
        }
    }
}
