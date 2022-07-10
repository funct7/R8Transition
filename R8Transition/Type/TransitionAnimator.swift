//
//  TransitionAnimator.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import UIKit

/**
 A class that implements protocols that are required to run a custom transition.
 
 This class can be used when the same animation parameters and animation block can be used for both presentaiton and dismissal.
 
 - Note: Since this class is an "animator" class, clients using this class instance should set the properties of the `UIViewController` instance
    that will be animated by the instance of this class, and also call `UIViewController.present(_:animated:completion)`
    or `UIViewController.dismiss(animated:completion:)` themselves after calling `TransitionAnimator.onChangeInteractionState(.began)`.
 */
open class TransitionAnimator : NSObject {
    
    // MARK: Interface
    
    open var params: AnimParams
    
    // MARK: Private
    
    private var _animator: UIViewPropertyAnimator!
    
    /// - Precondition: The input value should  **NOT** be `InteractionState.began`.
    private var _interactionListener: ((InteractionState) -> Void)? = nil
    
    // MARK: Initializer
    
    public init(params: AnimParams) {
        self.params = params
    }
    
}

// MARK: TransitionAnimator.AnimParams

public extension TransitionAnimator {
    
    struct AnimParams {
        public let duration: TimeInterval
        public let cubicBezierPoints: CubicBezierPoint
        /**
         The animation block that sets views according to the percentage value that is passed in.
         
         This block is called by the `TransitionAnimator` instance holding this value
         and will pass in a value ranging in `0.0 ... 1.0`.
         
         This animation block can be called any number of times--at least once--with any possible parameter,
         so no assumptions should be made as to the values that will be passed in or the order of invocation.
         
         - Note: Layout constraint updates should also be in this block if needed.
         If so, make sure to call `UIView.layoutIfNeeded()` after all constraints are updated.
         */
        public let animation: (CGFloat) -> Void
    
        public init(
            duration: TimeInterval = 0.35,
            cubicBezierPoints: CubicBezierPoint = .easeOut,
            animation: @escaping (CGFloat) -> Void)
        {
            self.duration = duration
            self.cubicBezierPoints = cubicBezierPoints
            self.animation = animation
        }
    }
    
}

// MARK: Implement - UIViewControllerTransitioningDelegate

extension TransitionAnimator : UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? { self }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? { self }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? { _isInteractive ? self : nil }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? { _isInteractive ? self : nil }
    
}

// MARK: Implement - UIViewControllerAnimatedTransitioning

extension TransitionAnimator : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { params.duration }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        _prepareAnimator(transitionContext: transitionContext)
        _animator.startAnimation()
    }
    
}

// MARK: Implement - UIViewControllerInteractiveTransitioning

extension TransitionAnimator : UIViewControllerInteractiveTransitioning {
    
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        assert(_interactionListener != nil)
        
        _prepareAnimator(transitionContext: transitionContext)
        _animator.pauseAnimation()
        _interactionListener = { [listener = _interactionListener!] state in
            listener(state)
            
            switch state {
            case .began:
                assertionFailure("Do not call for began")
            case .changed(let value):
                transitionContext.updateInteractiveTransition(CGFloat(value))
            case .canceled:
                transitionContext.cancelInteractiveTransition()
            case .ended:
                transitionContext.finishInteractiveTransition()
            }
        }
    }
    
}

// MARK: Implement - InteractionHandler

extension TransitionAnimator : InteractionHandler {
    
    private func updateAnimations(state: InteractionState) {
        assert(!state.isBegan, "Do not call _interactor for .began")
        
        switch state {
        case .began: return
            
        case .changed(let value):
            _animator.fractionComplete = CGFloat(value)
            
        case .canceled:
            _animator.isReversed = true
            _animator.startAnimation()
            _interactionListener = nil
            
        case .ended:
            _animator.startAnimation()
            _interactionListener = nil
        }
    }
    
    public func onChangeInteractionState(_ state: InteractionState) {
        assert(state.isBegan || _interactionListener != nil)
        
        switch state {
        case .began:
            _interactionListener = { [unowned self] in self.updateAnimations(state: $0) }
        default:
            _interactionListener!(state)
        }
    }
    
}

private extension TransitionAnimator {
    
    var _isInteractive: Bool { _interactionListener != nil }
    
    /// - Postcondition: `_animator != nil`
    func _prepareAnimator(transitionContext: UIViewControllerContextTransitioning) {
        let objectVC = transitionContext.objectVC!

        if objectVC.isBeingPresented {
            params.animation(0)
            transitionContext.containerView.addSubview(objectVC.view)
            
            _animator = .init(
                duration: params.duration,
                controlPoint1: params.cubicBezierPoints.point1,
                controlPoint2: params.cubicBezierPoints.point2,
                animations: { [params] in params.animation(1) })
            _animator.addCompletion { [params] _ in
                if transitionContext.transitionWasCancelled { params.animation(0) }
                
                transitionContext.completeTransition(transitionContext.transitionDidComplete)
            }
        } else {
            _animator = .init(
                duration: params.duration,
                controlPoint1: params.cubicBezierPoints.point1,
                controlPoint2: params.cubicBezierPoints.point2,
                animations: { [params] in params.animation(0) })
            _animator.addCompletion { [params] _ in
                if transitionContext.transitionWasCancelled {
                    params.animation(1)
                } else {
                    objectVC.view.removeFromSuperview()
                }
                
                transitionContext.completeTransition(transitionContext.transitionDidComplete)
            }
        }
    }
    
}
