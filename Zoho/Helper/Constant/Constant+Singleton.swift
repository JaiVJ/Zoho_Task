//
//  Constant+Singleton.swift
//  Zoho
//
//  Created by Jai on 25/09/21.
//

import Foundation

class ConstantManager
{
    static let appConstant = ConstantManager()
    private let nameQueue = DispatchQueue(label: "name.singleton", qos: .default, attributes: .concurrent)
        
    private var internetState: Bool = true
    
    var internetStatus: Bool {
        get {
            return nameQueue.sync {
                internetState
            }
        }
        set {
            nameQueue.async(flags: .barrier) {
                self.internetState = newValue
            }
        }
    }
    
}
