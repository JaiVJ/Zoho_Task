//
//  Constant.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//


import UIKit
import Alamofire
import Network

enum Result<T> {
    case success(T)
    case failure(Error)
}


class Network
{
    static func fecthData<K: Codable>(url: URL, httpMethod: HTTPMethod, completion: @escaping (Result<K>) -> Void) {
        
        if Connectivity.isConnectedToInternet()
        {
            Alamofire.request(url, method: httpMethod).responseJSON
            {
                (response) in
                               
                switch response.result
                {
                                        
                    case .success:
                        if let data = response.data
                        {
                            let decoder = JSONDecoder()
                            do {
                                let objects = try decoder.decode(K.self, from: data)
                                let result: Result<K> = Result.success(objects)
                                completion(result)
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
        else
        {
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : ZohoStrings.Error.no_internet])
            completion(.failure(error))
        }
    }
    
}

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private var monitor: NWPathMonitor
    private var status: NWPath.Status = .satisfied
    private var queue = DispatchQueue.global()


    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            
            if path.status == .satisfied {
                print("We're connected!")
                ConstantManager.appConstant.internetStatus = true
            } else {
                print("No connection.")
                ConstantManager.appConstant.internetStatus = false
            }
        }

    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

