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
    
    private var weightRange: ClosedRange<Double> = -1...1
    
    private var bias: Double?
    
    var Bias: Double? {
        get {
            return bias
        }

    }
        
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
            weights!.append(Double.random(in: weightRange))
        }
    }
    
    init(Inputs: Array<Vertex>, Outputs: Int) { // hidden layer vertex
        ID = Int.random(in: 0...Int.max)
        isOutput = false
        isInput = false
        inputVertices = Inputs
        InputValue = nil
        weights = Array<Double>()
        bias = Double.random(in: weightRange)
        for _ in 1...Outputs {
            weights!.append(Double.random(in: weightRange))
        }
    }
    
    init(Inputs: Array<Vertex>) { // output layer vertex
        ID = Int.random(in: 0...Int.max)
        isOutput = true
        isInput = false
        InputValue = nil
        inputVertices = Inputs
        //bias = Double.random(in: weightRange)
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
        bias = Parent.bias
        weights = Array<Double>()
        for i in Parent.weights! {
            weights!.append(i)
        }
        
        
    }
    
    /// delete the cached value for the node
    func clearCache() {
        cachedValue = nil
    }
    
    /// shows the value of the node based on its inputs
    /// - Returns: the node's value
    func Value() -> Double {
        if isInput {
            //print(sigmoid(z: InputValue! ))
            return InputValue!//sigmoid(z: InputValue!)
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
        value += bias ?? 0
        if isOutput {
            value = sigmoid(z: value)
        } else {
            value = relu(z: value)
        }
        // this line caches the value so that the vertex doesnt need to calculate its value
        // every time. this saves a significant amount of time.
        cachedValue = value
        return value
    }
    
    
    /// shows the weight of the edge between this vertex and the connected vertex
    /// - Parameter ConnectedVertex: the vertex connected to this vertex
    /// - Returns: the weight of the edge
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
    
    /// sets the value of the node
    /// - Parameter Value: the value to be set
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
    
    /// the ReLU activation function
    /// - Parameter z: input value
    /// - Returns: output value
    func relu(z: Double) -> Double {
        if z > 0.0 {
            return z
        } else {
            return 0.0
        }
    }
    
    /// the Sigmoid activation function
    /// - Parameter z: input value
    /// - Returns: output value
    func sigmoid(z: Double) -> Double {
        return  1.0 / (1.0 + exp( 0 - (1 * z)))
    }
    
    /// mutates the values of the weights and bias for the node
    /// - Parameter chance: the percentage chance of the vertex's weights and bias being mutated
    func mutate(chance: Double) {
        if weights != nil {
            var index = 0
            for _ in weights! {
                if chance > Double.random(in: 0.0...100.0) {
                    weights![index] = Double.random(in: weightRange)
                }
                index += 1
            }
        }
        
    
        if chance > Double.random(in: 0.0...100.0) {
            bias = Double.random(in: weightRange)
        }
    }
}
