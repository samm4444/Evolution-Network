//
//  FeatureValue.swift
//  Evolution Network
//
//  Created by Samuel Miller on 12/11/2021.
//

import UIKit

class FeatureValue: NSObject {

    let value: Double
    let max: Double
    
    init(value: Double, max: Double) {
        self.value = value
        self.max = max
    }
    
    var squashed: Double {
        get {
            return (value / max)
        }
    }
    
    
}
