//
//  CustomTransitionViewController.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import UIKit

/**
 An abstract `UIViewController` subclass provided for easy implementation.
 
 Using this class is not necessary.
 
 It is just provided for ease of use, since `transitioningDelegate` holds a weak reference, and the `TransitionAnimator` instance will have to be held somewhere.
 */
open class CustomTransitionViewController : UIViewController {
    
    /// - Note: Setting this property will update `transitioningDelegate`, but not vice versa.
    open lazy var transitionAnimator = CustomTransitionViewController.createDefaultTransitioner(animationProvider: animationProvider) {
        didSet { transitioningDelegate = transitionAnimator }
    }
    
    /// - Warning: Abstract method.
    open var animationProvider: FractionAnimationProvider { fatalError("implement") }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpCustomTransition()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCustomTransition()
    }
    
    private func setUpCustomTransition() {
        modalPresentationStyle = .custom
        transitioningDelegate = transitionAnimator
    }
    
}

public extension CustomTransitionViewController {
    
    /// A local default provided for convenience.
    static func createDefaultTransitioner(animationProvider: FractionAnimationProvider) -> TransitionAnimator {
        TransitionAnimator(params: .init(duration: 0.4, cubicBezierPoints: .easeOut, animation: animationProvider.updateViews(animationFraction:)))
    }
    
}
