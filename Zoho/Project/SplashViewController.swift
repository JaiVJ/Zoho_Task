//
//  SplashViewController.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController, CLLocationManagerDelegate {

    private var revealingLoaded = true
    
    var locationManager: CLLocationManager?
    var revealingSplashView: RevealingSplashView!

    override func viewDidLoad() {
        super.viewDidLoad()

        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "app_logo")!, iconInitialSize: CGSize(width: 170, height: 170), backgroundImage: UIImage(named: "splash_background")!)
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.duration = 4.0
                
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    override var prefersStatusBarHidden: Bool {
        return revealingLoaded
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    func startAnimation() {
        revealingSplashView.startAnimation() {
            self.revealingLoaded = false
            self.setNeedsStatusBarAppearanceUpdate()
            self.moveHome()
        }
    }

    
    func moveHome() {

        DispatchQueue.main.async {
            let vc = MainTabbarViewController.instantiate(fromAppStoryboard: .Main)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            startAnimation()
        }
    }
}
