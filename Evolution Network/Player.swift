//
//  Player.swift
//  Evolution Network
//
//  Created by Samuel Miller on 01/10/2021.
//

import UIKit
import SpriteKit

class Player: NSObject {

    let id: Int
    
    var stepSize: Double = 1 // maybe init this later
    
    var node: SKSpriteNode
    
    var isDead = false
    
    var won = false
    
    var winTime: Double = 0
    
    var brain: Brain
    
    private var weightMax: Double = 25.0
    
    init(Features: Int, HiddenLayers: Int, HiddenLayerSize: Int) {
        id = Int.random(in: 0...Int.max)
        
        node = SKSpriteNode(color: .red, size: CGSize(width: 3.5, height: 3.5))
        node.position = CGPoint(x: 200, y: 150)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 8))
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 1
        node.physicsBody?.mass = 1

        brain = Brain(Inputs: Features, Outputs: 4, HiddenLayers: HiddenLayers, HiddenLayerSize: HiddenLayerSize)
        
        
        
    }
    
    init(Parent: Player, ID: Int? = nil, colour: UIColor = .red) {
        if ID == nil {
            id = Int.random(in: 0...Int.max)
        } else {
            id = ID!
        }
        node = SKSpriteNode(color: colour, size: CGSize(width: 3.5, height: 3.5))
        node.position = CGPoint(x: 200, y: 150)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 1
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.physicsBody?.mass = 0.1
        node.physicsBody?.affectedByGravity = true
        node.name = "player " + String(describing: ID)
    
        brain = Brain(Parent: Parent.brain)

        
    }
    
    func nextVector(FeatureValues: Array<Double>) -> CGVector {
        let values = brain.compute(Inputs: FeatureValues)
        
        let dxV = values[0] - values[1]
        let dyV = values[2] - values[3]
        
        let dx = withinStep(Step: stepSize, Value: dxV, Max: 2)
        let dy = withinStep(Step: stepSize, Value: dyV, Max: 2)
        
        return CGVector(dx: dx, dy: dy)
    }
    
    
    
    func fitness(goal: SKSpriteNode) -> Double {
        var fitness: Double = 0
        
        if won { // give winners a high score based on the number of steps taken to get there
            return 2 + (1 / winTime)
        }
        
        if isDead && !won {
            return Double(1.0 / absDistanceBetween(PointOne: node.position, PointTwo: goal.position))
        } else {
            //fitness = 1 / Float(distance(positions.last!, goal))
            
            fitness = 1 + Double(1.0 / absDistanceBetween(PointOne: node.position, PointTwo: goal.position))
            
        }
        // 0 - 1 == died
        // 1 - 2 == stayed alive
        // 2+    == reached goal
        return fitness
    }
    
    func mutate(chance: Double) {
        brain.mutate(chance: chance)
    }
    
    
    
    
    func closestObstacle(nodes: [SKNode]) -> CGVector {
        var closest = SKNode()
        var closestDist: Double = .infinity
        for i in nodes {
            if i.name != "obstacle" {
                continue
            }
            let dist = absDistanceBetween(PointOne: node.position, PointTwo: i.position)
            if closestDist > dist {
                closest = i
                closestDist = dist
            }
        }
        return distanceBetween(PointOne: node.position, PointTwo: closest.position)
    }
    
    private func withinStep(Step: Double, Value: Double, Max: Double) -> Double {
        return (Value / Max) * Step
    }
    
    private func distanceBetween(PointOne: CGPoint, PointTwo: CGPoint) -> CGVector {
        let dx = PointTwo.x - PointOne.x
        let dy = PointTwo.y - PointOne.y
        return CGVector(dx: dx, dy: dy)
    }
    
    private func absDistanceBetween(PointOne: CGPoint, PointTwo: CGPoint) -> Double {
        return Double(hypotf(Float(PointTwo.x - PointOne.x), Float(PointTwo.y - PointOne.y)))
    }
    
}
