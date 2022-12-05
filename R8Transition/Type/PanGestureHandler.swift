//
//  PanGestureHandler.swift
//  R8Transition
//
//  Created by Josh Woomin Park on 2022/12/04.
//

import UIKit

open class PanGestureHandler : NSObject {
    
    /**
     The callback to be run when an end gesture is recognized.
     
     Use this callback when the bottom sheet should only emit the user's intention to close the bottom sheet,
     and actual routing should be determined as a result of computation by a controller unit.
     
     - Note: When this property is set to a non-`nil` value,
        the `transitionAnimator` of the `CustomTransitionViewController` will never receive
        `InteractionState.ended` as a result of user interaction.
        This means that the bottom sheet will never be dismissed by user gesture alone and
        `UIViewController.dismiss(animated:completion:)` must be called in order to dismiss the bottom sheet.
     */
    open var onGestureEnded: (() -> Void)? = nil

    @IBOutlet
    open weak var viewController: CustomTransitionViewController!
    
    private var _startY: CGFloat? = nil
    
    @IBAction
    open func gestureAction(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            viewController.transitionAnimator.onChangeInteractionState(.began)
            _startY = gesture.location(in: viewController.view).y
            viewController.dismiss(animated: true)
        
        case .changed:
            let span = viewController.view.frame.maxY - _startY!
            let transY = gesture.location(in: viewController.view).y - _startY!
            viewController.transitionAnimator.onChangeInteractionState(.changed(Double(transY / span)))
        
        case .cancelled:
            viewController.transitionAnimator.onChangeInteractionState(.canceled)
        
        case .ended:
            let newState: InteractionState
            
            if let _ = onGestureEnded {
                newState = .canceled
            } else {
                let span = viewController.view.frame.maxY - _startY!
                let transY = gesture.location(in: viewController.view).y - _startY!
                let shouldComplete = (transY / span) >= 0.5
                
                newState = shouldComplete ? .ended : .canceled
            }
            
            viewController.transitionAnimator.onChangeInteractionState(newState)
            onGestureEnded?()
        
        default:
            return
        }
    }
    
    public init(viewController: CustomTransitionViewController) {
        self.viewController = viewController
    }
    
    public override init() {
        super.init()
    }
    
}
