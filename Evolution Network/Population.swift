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
    var generation: Int = 0
    var averageFitness: Double = 0
    
    /// init a population
    /// - Parameters:
    ///   - PopulationSize: number of players
    ///   - Features: number of features in the player's brains
    ///   - HiddenLayers: number of hidden layers  in the player's brains
    ///   - HiddenLayerSize: number of nodes in each hidden layer of the player's brains
    init(PopulationSize: Int, Features: Int, HiddenLayers: Int, HiddenLayerSize: Int) {
        players = Array<Player>()
        size = PopulationSize
        
        for _ in 1...PopulationSize {
            players.append(Player(Features: Features, HiddenLayers: HiddenLayers, HiddenLayerSize: HiddenLayerSize))
        }
    }
    
    /// inits a population based on a given player
    /// - Parameters:
    ///   - withPlayer: player to be based on
    ///   - PopulationSize: size of the population
    init(withPlayer: Player, PopulationSize: Int) {
        let fittestPlayer = withPlayer
        var newPlayers: [Player] = []
        players = []
        size = PopulationSize
        
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
    
    /// creates a new generation of players based on the fittest player
    /// - Parameters:
    ///   - goal: the goal to be reached
    ///   - PopulationSize: size of the new population
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
        Global.data.brain = prevBestPlayer.brain
        newPlayers.append(prevBestPlayer)
        generation += 1
        players = newPlayers
    }
    
    
    /// returns the fittest player in the population
    /// - Parameter goal: the node of the goal to be reached
    /// - Returns: the fittest player
    func fittestPlayer(goal: SKSpriteNode) -> Player {
        var fittest: Player = Player(Features: 1, HiddenLayers: 1, HiddenLayerSize: 1)
        var highestFitness: Double = 0
        
        var deadTotal: Double = 0
        var deadCount: Double = 0
        var aliveTotal: Double = 0
        var aliveCount: Double = 0
        var totalFitness: Double = 0
        
        for i in players {
            let fitness = i.fitness(goal: goal)
            if i.isDead {
                deadTotal += fitness
                deadCount += 1
            } else {
                aliveTotal += fitness
                aliveCount += 1
            }
            totalFitness += fitness
            if fitness > highestFitness {
                fittest = i
                highestFitness = fitness
            }
        }
        
        self.averageFitness = totalFitness / Double(size)

        print("Generation " + String(describing: generation))
        print("average fitness = \(Global.data.population.averageFitness)")
        // not sure about reducing the mutation when most players get to the goal
        // its possible that they wont find a faster path...
        if averageFitness > 1 {
            Global.data.mutationRate = 0.3
        }
        print("dead average: " + String(describing: deadTotal / deadCount))
        print("alive average: " + String(describing: aliveTotal / aliveCount))
        print("")
        
        return fittest
    }
}
