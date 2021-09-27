//
//  WeatherView.swift
//  Zoho
//
//  Created by Jai on 27/09/21.
//

import Foundation
import UIKit
import Lottie

final class WeatherView: UIView {
    
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var lottieView: UIView!
    
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var rainChancesLbl: UILabel!

    let animationView = AnimationView()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setComponents()
        lottieInitialization()
    }
    
    func lottieInitialization() {
        lottieView.backgroundColor = .clear
        animationView.frame = lottieView.frame
        animationView.center = self.lottieView.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        lottieView.addSubview(animationView)
    }
    
    func setComponents() {
        todayLbl.text = ""
        temperatureLbl.text = ""
        conditionLbl.text = ""
        windSpeedLbl.text = ""
        humidityLbl.text = ""
        rainChancesLbl.text = ""

        todayLbl.font = UIFont.appGiloryBoldFontWith(size: 36)
        temperatureLbl.font = UIFont.appGiloryBoldFontWith(size: 28)
        conditionLbl.font = UIFont.appGiloryMediumFontWith(size: 18)
        windSpeedLbl.font = UIFont.appGiloryBoldFontWith(size: 16)
        humidityLbl.font = UIFont.appGiloryBoldFontWith(size: 16)
        rainChancesLbl.font = UIFont.appGiloryBoldFontWith(size: 16)
    }
    
    
    func loadData(_ viewModel: WeatherViewModelData) {
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


}
