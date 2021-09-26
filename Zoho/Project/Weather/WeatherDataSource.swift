//
//  WeatherDataSource.swift
//  Zoho
//
//  Created by Jai on 26/09/21.
//

import Foundation
import Alamofire

protocol WeatherDataSourceType {
    func fetchUsers(url: URL, httpMethod: HTTPMethod, completion: @escaping (_ result: (Result<WeatherModel>)) -> Void)
}

class WeatherDataSource: WeatherDataSourceType {

    func fetchUsers(url: URL, httpMethod: HTTPMethod, completion: @escaping (_ result: (Result<WeatherModel>)) -> Void) {
        
        Network.fecthData(url: url, httpMethod: httpMethod) { result in
            completion(result)
        }
    }

}
