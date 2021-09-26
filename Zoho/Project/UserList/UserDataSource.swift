//
//  UsersDataSource.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation
import Alamofire

protocol UserDataSourceType {
    func fetchUsers(url: URL, httpMethod: HTTPMethod, completion: @escaping (_ result: (Result<UserModal>)) -> Void)
}

class UserDataSource: UserDataSourceType {

    func fetchUsers(url: URL, httpMethod: HTTPMethod, completion: @escaping (_ result: (Result<UserModal>)) -> Void) {
        
        Network.fecthData(url: url, httpMethod: httpMethod) { result in
            completion(result)
        }        
    }

}
