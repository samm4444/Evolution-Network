//
//  Global.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit
import SpriteKit

class Global: NSObject {

    var populationSize: Int = 50
    
    var mutationRate: Double = 1
    
    var simDelay: Double = 0.05
    
    var population: Population
    
    var brain = Brain(Inputs: 8, Outputs: 1, HiddenLayers: 2, HiddenLayerSize: 5)
    
    var goal: SKSpriteNode?
    
    override init() {
        population = Population(PopulationSize: populationSize,
                                Features: 8,
                                HiddenLayers: 2,
                                HiddenLayerSize: 5)
    }
    
    static let data = Global()
}
