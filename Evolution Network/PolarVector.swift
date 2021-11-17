//
//  PolarPoint.swift
//  Evolution Network
//
//  Created by Samuel Miller on 12/11/2021.
//

import UIKit

class PolarVector: NSObject {
    /// Distance in direction
    var radius: CGFloat
    /// Angle rotation clockwise from north (degrees)
    var angle: CGFloat
    
    /// Vector described by a radius and an angle of rotation
    /// - Parameters:
    ///   - r: Distance in direction
    ///   - angle: Angle rotation clockwise from north (degrees)
    init(r: CGFloat, angle: CGFloat) {
        radius = r
        self.angle = angle
    }
    
    /// Convert Polar Vector to Cartesian (e.g. x=2, y=3 )
    /// - Returns: Vector as Cartesian Coord
    func toCartesian() -> CGVector {
        
        let dx = radius * cos(angle * Double.pi / 180)
        let dy = radius * sin(angle * Double.pi / 180)
        
        return CGVector(dx: dx, dy: dy)
        
    }
    
}
