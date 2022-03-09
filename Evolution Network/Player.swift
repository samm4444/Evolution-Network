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
    
    var stepSize: Double = 2.0
    
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
        node.blendMode = .replace

        brain = Brain(Inputs: Features, Outputs: 2, HiddenLayers: HiddenLayers, HiddenLayerSize: HiddenLayerSize)
        
        
        
    }
    
    init(withBrain: Brain) {
        id = Int.random(in: 0...Int.max)
        
        node = SKSpriteNode(color: .red, size: CGSize(width: 3.5, height: 3.5))
        node.position = CGPoint(x: 200, y: 150)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 8))
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = 1
        node.physicsBody?.mass = 1
        node.blendMode = .replace

        self.brain = withBrain
        
        
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
        node.physicsBody?.usesPreciseCollisionDetection = false
        node.physicsBody?.mass = 0.1
        node.physicsBody?.affectedByGravity = false
        node.blendMode = .replace

        node.name = "player " + String(describing: ID)
    
        brain = Brain(Parent: Parent.brain)

        
    }
    
    func nextVector(FeatureValues: Array<FeatureValue>) -> PolarVector {
        var squashedValues = Array<Double>()
        for i in FeatureValues {
            squashedValues.append(i.squashed)
        }
        let values = brain.compute(Inputs: squashedValues)
        
        //let dxV = values[0] - values[1]
        let AbsR = values[0]
        //let dyV = values[2] - values[3]
        
        //let dx = withinStep(Step: stepSize, Value: dxV, Max: 2)
        //let dy = withinStep(Step: stepSize, Value: dyV, Max: 2)
        
        let r = withinStep(Step: stepSize, Value: AbsR, Max: 1)
        //print(values[0])
        if id == Global.data.population.players[0].id {
            //print(values[0])
        }
        let theeta = withinStep(Step: 360, Value: values[1], Max: 1)
        
        return PolarVector(r: r, angle: theeta)
        //return CGVector(dx: dx, dy: dy)
    }
    
    
    
    /// The fitness function
    /// - Parameter goal: the node of the player that is being judged
    /// - Returns: The value of the fitness
    func fitness(goal: SKSpriteNode) -> Double {
        var fitness: Double = 0
        
        if won { // give winners a high score based on the number of steps taken to get there
            // won
            return 2 + (1 / winTime)
        }
        
        if isDead && !won {
            // dead

            return Double(1.0 / absDistanceBetween(PointOne: node.position, PointTwo: goal.position))
        } else {
            //fitness = 1 / Float(distance(positions.last!, goal))
            
            // alive
            fitness = 0.000 + Double(1.0 / absDistanceBetween(PointOne: node.position, PointTwo: goal.position))
            
        }
        
        // +2 bonus for reaching goal
        // +0.5 bonus for staying alive
        // no bonus for dying
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
        return Double(abs(hypotf(Float(PointTwo.x - PointOne.x), Float(PointTwo.y - PointOne.y))))
    }
    
}
