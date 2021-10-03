//
//  Population.swift
//  Evolution Network
//
//  Created by Samuel Miller on 01/10/2021.
//

import UIKit
import SpriteKit

class Population: NSObject {
    var players: [Player]
    var size: Int
    
    init(PopulationSize: Int, Features: Int, HiddenLayers: Int, HiddenLayerSize: Int) {
        players = Array<Player>()
        size = PopulationSize
        for _ in 1...PopulationSize {
            players.append(Player(Features: Features, HiddenLayers: HiddenLayers, HiddenLayerSize: HiddenLayerSize))
        }
    }
    
    func reproduce(goal: SKSpriteNode, PopulationSize: Int) {
        let fittestPlayer = fittestPlayer(goal: goal)
        var newPlayers: [Player] = []
        
        for i in players {
            i.node.removeFromParent()
            
        }
        
        for i in 0...(PopulationSize - 2) {
            var id: Int? = nil
            if i < players.count {
                id = players[i].id
            }
            let player = Player(Parent: fittestPlayer, ID: id)
            
            player.mutate(chance: Global.data.mutationRate)

            newPlayers.append(player)
        }
        
        let prevBestPlayer = Player(Parent: fittestPlayer, ID: fittestPlayer.id, colour: .systemGreen)
        
        newPlayers.append(prevBestPlayer)
        
        players = newPlayers
    }
    
    func fittestPlayer(goal: SKSpriteNode) -> Player {
        var fittest: Player = Player(Features: 1, HiddenLayers: 1, HiddenLayerSize: 1)
        var highestFitness: Double = 0
        for i in players {
            let fitness = i.fitness(goal: goal)
            if fitness > highestFitness {
                fittest = i
                highestFitness = fitness
            }
        }
        return fittest
    }
}
