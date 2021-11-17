//
//  Brain.swift
//  Evolution Network
//
//  Created by Samuel Miller on 02/10/2021.
//

import UIKit

class Brain: NSObject { //, NSCoding
//    func encode(with coder: NSCoder) {
//        var inputData = Array<Data>()
//        for i in inputLayer {
//            let d = try! NSKeyedArchiver.archivedData(withRootObject: i, requiringSecureCoding: false)
//            inputData.append(d)
//        }
//        var hiddenLayersData = Array<Array<Data>>()
//        var index = 0
//        for i in hiddenLayers {
//            hiddenLayersData.append(Array<Data>())
//            for l in i  {
//                let d = try! NSKeyedArchiver.archivedData(withRootObject: l, requiringSecureCoding: false)
//                hiddenLayersData[index].append(d)
//            }
//            index += 1
//        }
//        var outputData = Array<Data>()
//        for i in outputLayer {
//            let d = try! NSKeyedArchiver.archivedData(withRootObject: i, requiringSecureCoding: false)
//            outputData.append(d)
//        }
//        coder.encode(inputData, forKey: "inputLayer")
//        coder.encode(hiddenLayersData, forKey: "hiddenLayers")
//        coder.encode(outputData, forKey: "outputLayer")
//    }
//
//    required init?(coder: NSCoder) {
//        let _inputData = coder.decodeObject(forKey: "inputLayer") as! Array<Data>
//        let _hiddenLayersData = coder.decodeObject(forKey: "hiddenLayers") as! Array<Array<Data>>
//        let _outputData = coder.decodeObject(forKey: "outputLayer") as! Array<Data>
//
//        var _inputLayer = Array<Vertex>()
//        for i in _inputData {
//            let v = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Vertex.self, from: i)!
//            _inputLayer.append(v)
//        }
//
//        var _hiddenLayers = Array<Array<Vertex>>()
//        var index = 0
//        for i in _hiddenLayersData {
//            _hiddenLayers.append(Array<Vertex>())
//            for l in i  {
//                let v = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Vertex.self, from: l)!
//                _hiddenLayers[index].append(v)
//            }
//            index += 1
//        }
//
//        var _outputLayer = Array<Vertex>()
//        for i in _outputData {
//            let v = try! NSKeyedUnarchiver.unarchivedObject(ofClass: Vertex.self, from: i)!
//            _outputLayer.append(v)
//        }
//
//        self.inputLayer = _inputLayer
//        self.hiddenLayers = _hiddenLayers
//        self.outputLayer = _outputLayer
//    }
//
    
    var inputLayer: Array<Vertex>
    
    var hiddenLayers: Array<Array<Vertex>>
    
    var outputLayer: Array<Vertex>
    
    init(Parent: Brain) {
        inputLayer = Array<Vertex>()
        for i in Parent.inputLayer {
            let vertex = Vertex(Parent: i)
            inputLayer.append(vertex)
        }
        
        hiddenLayers = Array<Array<Vertex>>()
        var tempInputs = inputLayer
        var prevLayer = Array<Vertex>()
        var index = 1
        for layer in Parent.hiddenLayers {
            hiddenLayers.append(Array<Vertex>())
            for parentVertex in layer {

                let vertex = Vertex(Parent: parentVertex, Inputs: tempInputs)
                hiddenLayers[index - 1].append(vertex)
                prevLayer.append(vertex)
            }
            tempInputs = prevLayer
            index += 1
        }
        
        outputLayer = Array<Vertex>()
        for _ in Parent.outputLayer {
            let vertex = Vertex(Inputs: tempInputs)
            outputLayer.append(vertex)
        }
        
        
        // set output layers per vertex
        for i in inputLayer {
            i.setOutputVertices(Outputs: hiddenLayers[0])
        }
        
        var layerIndex = 0
        for layer in hiddenLayers {
            for i in layer {
                if layerIndex + 1 == hiddenLayers.count {
                    i.setOutputVertices(Outputs: outputLayer)
                } else {
                    i.setOutputVertices(Outputs: hiddenLayers[layerIndex + 1])
                }
                
            }
            layerIndex += 1
        }
    }
    
    init(Inputs: Int, Outputs: Int, HiddenLayers: Int, HiddenLayerSize: Int) {
        inputLayer = Array<Vertex>()
        for _ in 1...Inputs {
            let vertex = Vertex(Outputs: HiddenLayerSize)
            inputLayer.append(vertex)
        }
        
        hiddenLayers = Array<Array<Vertex>>()
        var tempInputs = inputLayer
        var prevLayer = Array<Vertex>()
        for i in 1...HiddenLayers {
            hiddenLayers.append(Array<Vertex>())
            for _ in 1...HiddenLayerSize {
                var nextOutputs = HiddenLayerSize
                if i == HiddenLayers {
                    nextOutputs = Outputs
                }
                let vertex = Vertex(Inputs: tempInputs, Outputs: nextOutputs)
                hiddenLayers[i - 1].append(vertex)
                prevLayer.append(vertex)
            }
            tempInputs = prevLayer
        }
        
        outputLayer = Array<Vertex>()
        for _ in 1...Outputs {
            let vertex = Vertex(Inputs: tempInputs)
            outputLayer.append(vertex)
        }
        
        
        for i in inputLayer {
            i.setOutputVertices(Outputs: hiddenLayers[0])
        }
        
        var layerIndex = 0
        for layer in hiddenLayers {
            for i in layer {
                if layerIndex + 1 == hiddenLayers.count {
                    i.setOutputVertices(Outputs: outputLayer)
                } else {
                    i.setOutputVertices(Outputs: hiddenLayers[layerIndex + 1])
                }
                
                
            }
            layerIndex += 1
        }
        
    }
    
    func compute(Inputs: Array<Double>) -> Array<Double> {
        var inputIndex = 0
        for i in inputLayer {
            i.setInputValue(Value: Inputs[inputIndex])
            inputIndex += 1
        }
        
        
        var outputs = Array<Double>()
        for i in outputLayer {
            outputs.append(i.Value())
        }
        
        clearVertexCache()
        return outputs
    }
    
    func clearVertexCache() {
        for i in inputLayer {
            i.clearCache()
        }
        
        for hiddenLayer in hiddenLayers {
            for i in hiddenLayer {
                i.clearCache()
            }
        }
        
        for i in outputLayer {
            i.clearCache()
        }
    }
    
    func mutate(chance: Double) {
        for i in inputLayer {
            i.mutate(chance: chance)
        }
        
        for hiddenLayer in hiddenLayers {
            for i in hiddenLayer {
                i.mutate(chance: chance)
            }
        }
        
        for i in outputLayer {
            i.mutate(chance: chance)
        }
        
    }
    
}
