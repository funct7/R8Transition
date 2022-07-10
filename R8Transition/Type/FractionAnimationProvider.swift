//
//  FractionAnimationProvider.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import UIKit

public protocol FractionAnimationProvider {
    
    func updateViews(animationFraction: CGFloat)
    
}

public enum FractionAnimationProviders {
    
    private struct _Instance : FractionAnimationProvider {
        func updateViews(animationFraction: CGFloat) { block(animationFraction) }
        let block: (CGFloat) -> Void
    }
    
    static public func create(_ block: @escaping (CGFloat) -> Void) -> FractionAnimationProvider { _Instance(block: block) }
    
}
