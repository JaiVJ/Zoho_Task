//
//  WeatherViewModel.swift
//  Zoho
//
//  Created by Jai on 26/09/21.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - Protocol

protocol WeatherViewModelData {
        
    var weather: WeatherModel? { get set }
    var city: String { get set }
    var dateFormatter: DateFormatter { get }
    var dayFormatter: DateFormatter { get }
    var timeFormatter: DateFormatter { get }
    var date: String { get }
    var weatherIcon: String { get }
    var temperature: String { get }
    var conditions: String { get }
    var windSpeed: String { get }
    var humidity: String { get }
    var rainChances: String { get }
    var refreshData: ((_ state: UserRefresh) -> Void)! { get set }

    func getTimeFor(timestamp: Int) -> String
    func getTempFor(temp: Double) -> String
    func getDayFor(timestamp: Int) -> String
    func getLocation()
    func getWeather(coord: CLLocationCoordinate2D?)
    func getUrlFor(lat: Double, lon: Double) -> String
    func getWeatherInternal(city: String, for urlString: URL)
    func getLottieAnimationFor(icon: String) -> String
    func getWeatherIconFor(icon: String) -> UIImage?

}

class WeatherViewModel: WeatherViewModelData {

    // MARK: - Init
    
    let dataSource: WeatherDataSourceType

    init(dataSource: WeatherDataSourceType, place: String = "Chennai") {
        self.city = place
        self.dataSource = dataSource
    }
    
    // MARK: - Declaration
    
    var refreshData: ((UserRefresh) -> Void)!
    var weather: WeatherModel?
    var city: String
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter
    }()
    
    
    var date: String {
        return dateFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(weather?.current?.dt ?? 0))
        )
    }
    
    var weatherIcon: String {
        if (weather?.current?.weather?.count ?? 0) > 0 {
            return weather?.current?.weather?[0].icon ?? ""
        }
        return "dayClearSky"
    }
    
    var temperature: String {
        return getTempFor(temp: weather?.current?.temp ?? 0.0)
    }
    
    var conditions: String {
        if (weather?.current?.weather?.count ?? 0) > 0 {
            return weather?.current?.weather?[0].main ?? ""
        }
        return ""
    }
    
    var windSpeed: String {
        return String(format: "%0.1f", weather?.current?.windSpeed ?? 0.0)
    }
    
    var humidity: String {
        return String(format: "%d%%", weather?.current?.humidity ?? 0)
    }
    
    var rainChances: String {
        return String(format: "%0.1f%%", weather?.current?.dewPoint ?? 0.0)
    }
    
    func getTimeFor(timestamp: Int) -> String {
        return timeFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(timestamp))
        )
    }
    
    func getTempFor(temp: Double) -> String {
        return String(format: "%0.1f", temp)
    }
    
    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(timestamp))
        )
    }
        
    // MARK: - Fetch Data

    func getLocation() {
        CLGeocoder().geocodeAddressString(city) { (placemarks, error) in
            if let places = placemarks, let place = places.first {
                self.getWeather(coord: place.location?.coordinate)
            }
        }
    }
    
    func getWeather(coord: CLLocationCoordinate2D?) {
        if let coord = coord {
            let urlString =  URL.init(string: getUrlFor(lat: coord.latitude, lon: coord.longitude))!
            getWeatherInternal(city: city, for: urlString)
        } else {
            let urlString =  URL.init(string: getUrlFor(lat: 0, lon: 0))!
            getWeatherInternal(city: city, for: urlString)
        }
    }
    
    func getUrlFor(lat: Double, lon: Double) -> String {
        return "\(APIList.WEATHER_URL)onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(WEATHER_KEY)&units=metric"
    }

    
    func getWeatherInternal(city: String, for urlString: URL) {
        
        dataSource.fetchUsers(url: urlString, httpMethod: .get) { response in
            switch response {
                case .success(let result):
                
                self.weather = result
                    self.refreshData(.success)
                break
                case .failure(let error):
                    self.refreshData(.failure(error.localizedDescription))
                break
            }
            
        }
    }
    
    // MARK: - Lottie & Icons
    
    func getLottieAnimationFor(icon: String) -> String {
        switch icon {
        case "01d":
            return "dayClearSky"
        case "01n":
            return "nightClearSky"
        case "02d":
            return "dayFewClouds"
        case "02n":
            return "nightFewClouds"
        case "03d":
            return "dayScatteredClouds"
        case "03n":
            return "nightScatteredClouds"
        case "04d":
            return "dayBrokenClouds"
        case "04n":
            return "nightBrokenClouds"
        case "09d":
            return "dayShowerRains"
        case "09n":
            return "nightShowerRains"
        case "10d":
            return "dayRain"
        case "10n":
            return "nightRain"
        case "11d":
            return "dayThunderstorm"
        case "11n":
            return "nightThunderstorm"
        case "13d":
            return "daySnow"
        case "13n":
            return "nightSnow"
        case "50d":
            return "dayClearSky"
        case "50n":
            return "dayClearSky"
        default:
            return "dayClearSky"
        }
    }
    
    func getWeatherIconFor(icon: String) -> UIImage? {
        switch icon {
        case "01d":
            return UIImage(systemName: "sun.max.fill")
        case "01n":
            return UIImage(systemName: "moon.fill")
        case "02d":
            return UIImage(systemName: "cloud.sun.fill")
        case "02n":
            return UIImage(systemName: "cloud.moon.fill")
        case "03d":
            return UIImage(systemName: "cloud.fill")
        case "03n":
            return UIImage(systemName: "cloud.fill")
        case "04d":
            return UIImage(systemName: "cloud.fill")
        case "04n":
            return UIImage(systemName: "cloud.fill")
        case "09d":
            return UIImage(systemName: "cloud.drizzle.fill")
        case "09n":
            return UIImage(systemName: "cloud.drizzle.fill")
        case "10d":
            return UIImage(systemName: "cloud.heavyrain.fill")
        case "10n":
            return UIImage(systemName: "cloud.heavyrain.fill")
        case "11d":
            return UIImage(systemName: "cloud.bolt.fill")
        case "11n":
            return UIImage(systemName: "cloud.bolt.fill")
        case "13d":
            return UIImage(systemName: "cloud.snow.fill")
        case "13n":
            return UIImage(systemName: "cloud.snow.fill")
        case "50d":
            return UIImage(systemName: "cloud.fog.fill")
        case "50n":
            return UIImage(systemName: "cloud.fog.fill")
        default:
            return UIImage(systemName: "sun.max.fill")
        }
    }
}
