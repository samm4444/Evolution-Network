//
//  Population.swift
//  Evolution Network
//
//  Created by Samuel Miller on 01/10/2021.
//

import UIKit

class Population: NSObject {
    var players: [Player]
    var size: Int
    
    init(PopulationSize: Int) {
        players = Array<Player>()
        size = PopulationSize
        for _ in 0...PopulationSize {
            players.append(Player())
        }
    }
}
