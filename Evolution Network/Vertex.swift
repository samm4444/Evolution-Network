//
//  Vertex.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit

class Vertex: NSObject {

    let ID: Int
    
    private var weights: Array<Double>?
    
    private var outputVertices: Array<Vertex>?
    
    private var inputVertices: Array<Vertex>?
    
    private let isOutput: Bool
    
    private let isInput: Bool

    private var InputValue: Double?
    
    private var cachedValue: Double?
        
    func setOutputVertices(Outputs: Array<Vertex>) {
        outputVertices = Outputs
    }
    
    init(Outputs: Int) { // input layer vertex
        ID = Int.random(in: 0...Int.max)
        isInput = true
        isOutput = false
        InputValue = nil
        weights = Array<Double>()
        for _ in 1...Outputs {
            weights!.append(Double.random(in: -10...10))
        }
    }
    
    init(Inputs: Array<Vertex>, Outputs: Int) { // hidden layer vertex
        ID = Int.random(in: 0...Int.max)
        isOutput = false
        isInput = false
        inputVertices = Inputs
        InputValue = nil
        weights = Array<Double>()
        for _ in 1...Outputs {
            weights!.append(Double.random(in: -10...10))
        }
    }
    
    init(Inputs: Array<Vertex>) { // output layer vertex
        ID = Int.random(in: 0...Int.max)
        isOutput = true
        isInput = false
        InputValue = nil
        inputVertices = Inputs
    }
    
    init(Parent: Vertex, Inputs: Array<Vertex>? = nil) {
        ID = Int.random(in: 0...Int.max)
        InputValue = nil
        
        if Parent.isInput {
            isInput = true
            isOutput = false
            
            weights = Array<Double>()
            for i in Parent.weights! {
                weights!.append(i)
            }
            
            return
        }
        
        isInput = false
        isOutput = false
        
        inputVertices = Inputs!
        
        weights = Array<Double>()
        for i in Parent.weights! {
            weights!.append(i)
        }
        
        
    }
    
    func clearCache() {
        cachedValue = nil
    }
    
    func Value() -> Double {
        if isInput {
            return InputValue!
        }
        if cachedValue != nil {
            return cachedValue!
        }
        
        var value: Double = 0.0
        
        for i in inputVertices! {
            let w = i.Weight(ConnectedVertex: self)
            let v = i.Value()
            let weightedValue = w * v
            value += weightedValue
        }
        value = sigmoid(z: value)
        cachedValue = value
        return value
    }
    
    
    func Weight(ConnectedVertex: Vertex) -> Double {
        if isOutput {
            return 1.0
        }
        
        var index = 0
        for i in outputVertices! {
            if i == ConnectedVertex {
                return weights![index]
            }
            index += 1
        }
        return 0
    }
    
    func setInputValue(Value: Double) {
        if isInput {
            InputValue = Value
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherVertex = object as? Vertex {
            return self.ID == otherVertex.ID
        }
        return false
    }
    
    func sigmoid(z: Double) -> Double {
        return  1.0 / (1.0 + exp(-z))
    }

    func mutate(chance: Double) {
        var index = 0
        for _ in weights! {
            if chance > Double.random(in: 0.0...100.0) {
                weights![index] = Double.random(in: -10...10)
            }
            index += 1
        }
    }
}
