//
//  Global.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit
import SpriteKit

class Global: NSObject {

    var populationSize: Int = 15
    
    var mutationRate: Double = 0.54347
    
    var simDelay: Double = 0.03
    
    var population: Population
    
    var brain: Brain
    
    var goal: SKSpriteNode?
    
    override init() {
        population = Population(PopulationSize: populationSize,
                                Features: 19,
                                HiddenLayers: 2,
                                HiddenLayerSize: 12) // 8 features w/o diagonals // 7 size
        brain = population.players.first!.brain
    }
    
    static let data = Global()
}
