//
//  SplashViewController.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import UIKit

class SplashViewController: UIViewController {

    private var revealingLoaded = true

    override func viewDidLoad() {
        super.viewDidLoad()

        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "app_logo")!, iconInitialSize: CGSize(width: 170, height: 170), backgroundImage: UIImage(named: "splash_background")!)
        
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.duration = 4.0
        
        revealingSplashView.startAnimation() {
            self.revealingLoaded = false
            self.setNeedsStatusBarAppearanceUpdate()
            self.moveHome()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.moveHome()
    }

    override var prefersStatusBarHidden: Bool {
        return revealingLoaded
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }

    
    func moveHome() {

        DispatchQueue.main.async {
            let vc = MainTabbarViewController.instantiate(fromAppStoryboard: .Main)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }

    }

}
