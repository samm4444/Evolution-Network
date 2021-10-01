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
    
    var stepSize: Double = 5 // maybe init this later
    
    var node: SKSpriteNode

    // weights
    private var closestObstacleWeightX: Double
    private var closestObstacleWeightY: Double
    private var goalWeightX: Double
    private var goalWeightY: Double
    
    private var weightMax: Double = 10.0
    
    override init() {
        id = Int.random(in: 0...Int.max)
        
        node = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 5))
        node.position = CGPoint(x: 200, y: 40)
        //node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 5))
        
        // set random weights
        closestObstacleWeightX = Double.random(in: -weightMax...weightMax)
        closestObstacleWeightY = Double.random(in: -weightMax...weightMax)
        goalWeightX = Double.random(in: -weightMax...weightMax)
        goalWeightY = Double.random(in: -weightMax...weightMax)
        
        
    }
    
    private func nextDX(DistToObstacle: CGFloat, DistToGoal: CGFloat, WorldX: Double) -> Double {
        let value = (closestObstacleWeightX * DistToObstacle) + (goalWeightX * DistToGoal)
        let max: Double = (weightMax * WorldX) + (weightMax * WorldX)
        let dx = withinStep(Step: stepSize, Value: value, Max: max)
        return dx
    }
    
    private func nextDY(DistToObstacle: CGFloat, DistToGoal: CGFloat, WorldY: Double) -> Double {
        let value = (closestObstacleWeightY * DistToObstacle) + (goalWeightY * DistToGoal)
        let max: Double = (weightMax * WorldY) + (weightMax * WorldY)
        let dy = withinStep(Step: stepSize, Value: value, Max: max)
        return dy
    }
    
    func nextVector(ClosestObstacle: SKSpriteNode, Goal: SKSpriteNode, WorldX: Double, WorldY: Double) -> CGVector {
        
        let DistanceToObstacle = distanceBetween(PointOne: node.position,
                                                 PointTwo: ClosestObstacle.position)
        let DistanceToGoal = distanceBetween(PointOne: node.position,
                                                 PointTwo: Goal.position)
        
        let dx = nextDX(DistToObstacle: DistanceToObstacle.dx,
                        DistToGoal: DistanceToGoal.dx,
                        WorldX: WorldX)
        let dy = nextDY(DistToObstacle: DistanceToObstacle.dy,
                        DistToGoal: DistanceToGoal.dy,
                        WorldY: WorldY)
        
        //print("\(goalWeightY) = \(withinStep(Step: stepSize, Value: goalWeightY, Max: weightMax))")
        return CGVector(dx: dx, dy: dy)
    }
    
    private func withinStep(Step: Double, Value: Double, Max: Double) -> Double {
        return (Value / Max) * Step
    }
    
    private func distanceBetween(PointOne: CGPoint, PointTwo: CGPoint) -> CGVector {
        let dx = PointTwo.x - PointOne.x
        let dy = PointTwo.y - PointOne.y
        return CGVector(dx: dx, dy: dy)
    }
    
}
