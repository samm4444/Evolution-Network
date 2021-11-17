//
//  Vertex.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit

class Vertex: NSObject {//, NSCoding
//    func encode(with coder: NSCoder) {
//        coder.encode(ID, forKey: "ID")
//        coder.encode(weights, forKey: "weights")
//        var outputVerticesData = Array<Data>()
//        for i in outputVertices ?? [] { // gets stuck in a loop
//            let d = try! NSKeyedArchiver.archivedData(withRootObject: i, requiringSecureCoding: false)
//            outputVerticesData.append(d)
//        }
//
//        coder.encode(outputVerticesData, forKey: "outputVertices")
//
//        var inputVerticesData = Array<Data>()
//        for i in inputVertices ?? [] {
//            let d = try! NSKeyedArchiver.archivedData(withRootObject: i, requiringSecureCoding: false)
//            inputVerticesData.append(d)
//        }
//
//        coder.encode(inputVerticesData, forKey: "inputVertices")
//        coder.encode(isOutput, forKey: "isOutput")
//        coder.encode(isInput, forKey: "isInput")
//        coder.encode(InputValue, forKey: "InputValue")
//        coder.encode(weightRange, forKey: "weightRange")
//        coder.encode(bias, forKey: "bias")
//    }
//
//    required init?(coder: NSCoder) {
//        let _ID = coder.decodeObject(forKey: "ID") as! Int
//        let _weights = coder.decodeObject(forKey: "weights") as? Array<Double>
//
//        let _outputVerticesData = coder.decodeObject(forKey: "outputVertices") as! Array<Data>
//        var _outputVertices = Array<Vertex>()
//        for i in _outputVerticesData {
//            let v = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Vertex.self, from: i)!
//            _outputVertices.append(v)
//        }
//
//        let _inputVerticesData = coder.decodeObject(forKey: "inputVertices") as! Array<Data>
//        var _inputVertices = Array<Vertex>()
//        for i in _inputVerticesData {
//            let v = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Vertex.self, from: i)!
//            _inputVertices.append(v)
//        }
//
//        let _isOutput = coder.decodeObject(forKey: "isOutput") as! Bool
//        let _isInput = coder.decodeObject(forKey: "isInput") as! Bool
//        let _InputValue = coder.decodeObject(forKey: "InputValue") as? Double
//        let _weightRange = coder.decodeObject(forKey: "weightRange") as! ClosedRange<Double>
//        let _bias = coder.decodeObject(forKey: "bias") as? Double
//
//        self.ID = _ID
//        self.weights = _weights
//        self.outputVertices = _outputVertices
//        self.inputVertices = _inputVertices
//        self.isOutput = _isOutput
//        self.isInput = _isInput
//        self.InputValue = _InputValue
//        self.cachedValue = nil
//        self.weightRange = _weightRange
//        self.bias = _bias
//    }
//    

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
    
    func clearCache() {
        cachedValue = nil
    }
    
    func Value() -> Double {
        if isInput {
            //print(sigmoid(z: InputValue! ))
            return sigmoid(z: InputValue!)
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
        return  1.0 / (1.0 + exp( 0 - (8 * z)))
    }

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
