//
//  WeatherViewController.swift
//  Zoho
//
//  Created by Jai on 26/09/21.
//

import UIKit
import Lottie

class WeatherViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    var gradientLayer = CAGradientLayer()
    private var viewModel: WeatherViewModelData!

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var weatherMainView: CustomView!
    
    var weatherView: WeatherView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        viewModel = WeatherViewModel(dataSource: WeatherDataSource())
        createGredientBackground()
        mainView.isHidden = true
        searchTxt.delegate = self
        viewBind()
        
        weatherView = .fromNib()
        weatherView.frame = weatherMainView.bounds
        weatherMainView.addSubview(weatherView)
    }
    
    
    private func viewBind() {
        viewModel.refreshData = {
                [unowned self] result in
                switch result {
                case .success:
                    self.bindData()
                    break;
                case .failure(let error):

                    self.showAlertError(messageStr: error)
                break;
            }
        }
    }
    
    private func bindData() {
        mainView.isHidden = false
        cityLbl.text = viewModel.city
        dateLbl.text = viewModel.date
        weatherView.loadData(viewModel)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocation()
    }
    
    override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         gradientLayer.frame = view.layer.bounds
    }


    func createGredientBackground() {

         let colorTop =  UIColor.init(named: "weather_gradiant_top")!.cgColor
         let colorBottom = UIColor.init(named: "weather_gradiant_bottom")!.cgColor
            
         gradientLayer.colors = [colorTop, colorBottom]
         gradientLayer.locations = [0.0, 1.0]
         gradientLayer.frame = self.view.bounds
                    
         self.view.layer.insertSublayer(gradientLayer, at:0)
    }

}

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        
        if !textField.text!.isEmpty {            
            let vc = WeatherDetailsViewController.instantiate(fromAppStoryboard: .Main)
            vc.viewModel = WeatherViewModel(dataSource: WeatherDataSource(), place: textField.text!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
       return true
    }
}

extension WeatherViewController {
    
    func checkLocation()
    {
        if LocationManager.isLocationEnabled()
        {
            viewModel.getLocation()
        }
        else
        {
            mainView.isHidden = true

            let alertView = UIAlertController(title: ZohoStrings.Weather.locationDisable, message: ZohoStrings.Weather.locationDisableDescription, preferredStyle: .alert)

            alertView.addAction(UIAlertAction(title: ZohoStrings.Weather.settings, style: .default, handler:
            {
                (alertAction) -> Void in
                
                
                if let bundleId = Bundle.main.bundleIdentifier, let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
                {
                    print("URL = ",url)
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }))
            
            alertView.addAction(UIAlertAction(title: ZohoStrings.Error.no, style: .default, handler:nil))
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func setComponents() {
        searchTxt.text = ""
        cityLbl.text = ""
        dateLbl.text = ""
        searchTxt.font = UIFont.appGiloryMediumFontWith(size: 18)
        cityLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
        dateLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
    }
    
}
