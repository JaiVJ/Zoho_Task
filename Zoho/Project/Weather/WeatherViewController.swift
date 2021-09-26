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
    
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var lottieView: UIView!
    
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    
    @IBOutlet weak var windSpeedView: CustomView!
    @IBOutlet weak var humidityView: CustomView!
    @IBOutlet weak var rainChancesView: CustomView!
    
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var rainChancesLbl: UILabel!
    
    let animationView = AnimationView()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        viewModel = WeatherViewModel(dataSource: WeatherDataSource())
        createGredientBackground()
        lottieInitialization()
        mainView.isHidden = true
        searchTxt.delegate = self
        viewBind()
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
        todayLbl.text = "Today"
        let animation = Animation.named(viewModel.getLottieAnimationFor(icon: viewModel.weatherIcon))
        animationView.animation = animation
        animationView.play()
        temperatureLbl.text = "\(viewModel.temperature)℃"
        conditionLbl.text = viewModel.conditions
  
        windSpeedLbl.text = "\(viewModel.windSpeed) km/hr"
        humidityLbl.text = "\(viewModel.humidity)"
        rainChancesLbl.text = "\(viewModel.rainChances)"
        
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
        todayLbl.text = ""
        temperatureLbl.text = ""
        conditionLbl.text = ""
        windSpeedLbl.text = ""
        humidityLbl.text = ""
        rainChancesLbl.text = ""
        searchTxt.font = UIFont.appGiloryMediumFontWith(size: 18)
        cityLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
        dateLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
        todayLbl.font = UIFont.appGiloryBoldFontWith(size: 36)
        temperatureLbl.font = UIFont.appGiloryBoldFontWith(size: 28)
        conditionLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
        windSpeedLbl.font = UIFont.appGiloryBoldFontWith(size: 16)
        humidityLbl.font = UIFont.appGiloryBoldFontWith(size: 16)
        rainChancesLbl.font = UIFont.appGiloryBoldFontWith(size: 16)
    }
    
    func lottieInitialization() {
        lottieView.backgroundColor = .clear
        animationView.frame = lottieView.frame
        animationView.center = self.lottieView.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        lottieView.addSubview(animationView)

    }
}
