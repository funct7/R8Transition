//
//  CubicBezierPoint.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import UIKit

public struct CubicBezierPoint {
    public let point1: CGPoint
    public let point2: CGPoint

    public init(point1: CGPoint, point2: CGPoint) {
        self.point1 = point1
        self.point2 = point2
    }
    
    public init(points: (CGPoint, CGPoint)) {
        self.init(point1: points.0, point2: points.1)
    }
}

public extension CubicBezierPoint {
    
    static let easeOut = CubicBezierPoint(point1: CGPoint(x: 0.33, y: 1), point2: CGPoint(x: 0.68, y: 1))
    
}
