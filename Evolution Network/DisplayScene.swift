//
//  DisplayScene.swift
//  Evolution Network
//
//  Created by Samuel Miller on 05/11/2021.
//

import SpriteKit
import GameplayKit

class DisplayScene: SKScene {

    var nodes: Array<SKShapeNode> = Array<SKShapeNode>()
    
    override func sceneDidLoad() {
        
        
        displayBrain(brain: Global.data.brain)
        
        
    }
    
    func xForCircles(R: Int, circleCount: Int) -> Int {
        
        return (R * 2) * circleCount
        
        
    }
    
    func displayBrain(brain: Brain) {
        removeAllChildren()
        var Y = 150
        let vSpacing = 270
        
        
        createNodes(brain: brain, startX: 80, startY: Y)

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayBrain(brain: Global.data.brain)
    }
    
    func createLayer(inputVertices: Array<Vertex>, outputVertices: Array<Vertex>, startX: Int, startY: Int) {
        
        var aNodes = Array<SKShapeNode>()
        var bNodes = Array<SKShapeNode>()
        
        let r: CGFloat = 30
        
        let maxLineWidth = 10
        
        var x = startX
        var y = startY
        let hSpacing = 77
        let vSpacing = 270
        
        for a in inputVertices {
            var node = SKShapeNode(circleOfRadius: r)
            node.fillColor = .white
            if a.Bias != nil && a.Bias != 0 {
                let alpha = abs((a.Bias!))
                node.fillColor = .init(white: 255, alpha: alpha)
            }
            node.position = CGPoint(x: x,y: y)
            aNodes.append(node)
            addChild(node)
            x += hSpacing
        }
        
        x = startX
        y += vSpacing
        for a in outputVertices {
            var node = SKShapeNode(circleOfRadius: r)
            node.fillColor = .white
            if a.Bias != nil && a.Bias != 0 {
                let alpha = abs((a.Bias!))
                node.fillColor = .init(white: 255, alpha: alpha)
            }
            node.position = CGPoint(x: x,y: y)
            bNodes.append(node)
            addChild(node)
            x += hSpacing
        }
        
        var aIndex = 0
        var bIndex = 0
        for a in inputVertices {
            bIndex = 0
            for b in outputVertices {
                var line = SKShapeNode()
                var pathToDraw = CGMutablePath()
                pathToDraw.move(to: aNodes[aIndex].position)
                pathToDraw.addLine(to: bNodes[bIndex].position)
                line.path = pathToDraw
                line.lineWidth = 4
                line.strokeColor = .white
                addChild(line)
                bIndex += 1
            }
            aIndex += 1
        }
        
        
        
        
    }
    
    
    func createNodes(brain: Brain, startX: Int, startY: Int) {
        
        var inNodes = Array<SKShapeNode>()
        var hiddenNodes = Array<Array<SKShapeNode>>()
        var outNodes = Array<SKShapeNode>()
        
        let r: CGFloat = 30
        
        let maxLineWidth = 10
        
        var x = startX
        var y = startY
        let hSpacing = 77
        let vSpacing = 270
        
        for a in brain.inputLayer {
            var node = SKShapeNode(circleOfRadius: r)
            node.fillColor = .white
            if a.Bias != nil && a.Bias != 0 {
                let alpha = abs((a.Bias!))
                node.fillColor = .init(white: 255, alpha: alpha)
            }
            node.position = CGPoint(x: x,y: y)
            inNodes.append(node)
            addChild(node)
            x += hSpacing
        }
        
        x = startX
        y += vSpacing
        
        
        for i in 0...(brain.hiddenLayers.count - 1) {
            var tempHiddenNodes = Array<SKShapeNode>()
            for a in brain.hiddenLayers[i] {
                var node = SKShapeNode(circleOfRadius: r)
                node.fillColor = .white
                if a.Bias != nil && a.Bias != 0 {
                    let alpha = abs((a.Bias!))
                    node.fillColor = .init(white: 255, alpha: alpha)
                }
                node.position = CGPoint(x: x,y: y)
                tempHiddenNodes.append(node)
                addChild(node)
                x += hSpacing
            }
            hiddenNodes.append(tempHiddenNodes)
            x = startX
            y += vSpacing
        }
        
        for a in brain.outputLayer {
            var node = SKShapeNode(circleOfRadius: r)
            node.fillColor = .white
            if a.Bias != nil && a.Bias != 0 {
                let alpha = abs((a.Bias!))
                node.fillColor = .init(white: 255, alpha: alpha)
            }
            node.position = CGPoint(x: x,y: y)
            outNodes.append(node)
            addChild(node)
            x += hSpacing
        }
        
        // draw lines --
        
        let maxWidth = 3
        
        // in to first hidden
        
        var inIndex = 0
        var hiddenIndex = 0
        for a in inNodes {
            hiddenIndex = 0
            for b in hiddenNodes[0] {
                var line = SKShapeNode()
                var pathToDraw = CGMutablePath()
                pathToDraw.move(to: inNodes[inIndex].position)
                pathToDraw.addLine(to: hiddenNodes[0][hiddenIndex].position)
                line.path = pathToDraw
                line.lineWidth = abs( brain.inputLayer[inIndex].Weight(ConnectedVertex: brain.hiddenLayers[0][hiddenIndex])) * Double(maxWidth)
                line.strokeColor = .white
                addChild(line)
                hiddenIndex += 1
            }
            inIndex += 1
        }
        
        // hidden layers
        
        var prevLayer = 0
        for layer in 0...(hiddenNodes.count - 1) {
            var aIndex = 0
            var bIndex = 0
            for a in hiddenNodes[prevLayer] {
                hiddenIndex = 0
                for b in hiddenNodes[layer] {
                    var line = SKShapeNode()
                    var pathToDraw = CGMutablePath()
                    pathToDraw.move(to: a.position)
                    pathToDraw.addLine(to: b.position)
                    line.path = pathToDraw
                    line.lineWidth = abs( brain.hiddenLayers[prevLayer][aIndex].Weight(ConnectedVertex: brain.hiddenLayers[layer][bIndex])) * Double(maxWidth)
                    line.strokeColor = .white
                    addChild(line)
                    bIndex += 1
                }
                bIndex = 0
                aIndex += 1
            }
            prevLayer = layer
        }
        
        // last hidden to output
        
        hiddenIndex = 0
        var outIndex = 0
        for a in hiddenNodes[hiddenNodes.count - 1] {
            outIndex = 0
            for b in outNodes {
                var line = SKShapeNode()
                var pathToDraw = CGMutablePath()
                pathToDraw.move(to: a.position)
                pathToDraw.addLine(to: b.position)
                line.path = pathToDraw
                line.lineWidth = abs( brain.hiddenLayers[hiddenNodes.count - 1][hiddenIndex].Weight(ConnectedVertex: brain.outputLayer[outIndex])) * Double(maxWidth)
                line.strokeColor = .white
                addChild(line)
                outIndex += 1
            }
            outIndex = 0
            hiddenIndex += 1
        }
        
        
    }
 
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        
    }
}
