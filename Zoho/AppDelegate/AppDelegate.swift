//
//  AppDelegate.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NetworkMonitor.shared.startMonitoring()
        
        CLLocationManager().requestWhenInUseAuthorization()

        
        let vc = UINavigationController(rootViewController: SplashViewController.instantiate(fromAppStoryboard: .Main))
        vc.isNavigationBarHidden = true
        window?.rootViewController = vc;
        window?.makeKeyAndVisible()
        
        return true
    }


}

