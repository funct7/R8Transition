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
    
    /**
     Creates a `FractionAnimationProvider` instance that calls `UIView.layoutIfNeeded()` at the end of the block.
     
     - Parameters:
        - viewController: The `UIViewController` instance whose view will be animated by `block`.
        - block: The animation block that sets the views in place according to the animation progress.
        - progress: The value denoting at what point the animation is. `0.0` means the bottom sheet is at its initial position.
     */
    static public func makeStandard<VC>(
        _ viewController: VC,
        _ block: @escaping (_ viewController: VC, _ progress: CGFloat) -> Void) -> FractionAnimationProvider
    where VC : UIViewController
    {
        _Instance { [weak viewController] progress in
            guard let viewController = viewController else { return }
            block(viewController, progress)
            viewController.view.layoutIfNeeded()
        }
    }
    
}
