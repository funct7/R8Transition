//
//  ShareViewController.swift
//  R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import R8Transition

class ShareViewController : CustomTransitionViewController {
    
    override var animationProvider: FractionAnimationProvider {
        FractionAnimationProviders.create { [weak vc = self] progress in
            guard let vc = vc else { return }
            vc.view.backgroundColor = UIColor(white: 0, alpha: 0.3 * progress)
            vc.bottomSheetBottomToViewBottom.constant = vc.bottomSheetView.frame.height * (1 - progress)
            vc.view.layoutIfNeeded()
        }
    }
    
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))

    @IBOutlet private weak var bottomSheetView: UIView! {
        didSet { bottomSheetView.addGestureRecognizer(panGesture) }
    }
    
    @IBOutlet private var bottomSheetBottomToViewBottom: NSLayoutConstraint!
    
    @IBAction private func backgroundAction() {
        dismiss(animated: true)
    }
    
    private var startY: CGFloat? = nil
    
    @objc private func panAction(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            transitionAnimator.onChangeInteractionState(.began)
            startY = gesture.location(in: view).y
            dismiss(animated: true)
        
        case .changed:
            let span = view.frame.maxY - startY!
            let transY = gesture.location(in: view).y - startY!
            transitionAnimator.onChangeInteractionState(.changed(Double(transY / span)))
        
        case .cancelled:
            transitionAnimator.onChangeInteractionState(.canceled)
        
        case .ended:
            let span = view.frame.maxY - startY!
            let transY = gesture.location(in: view).y - startY!
            let shouldComplete = (transY / span) >= 0.5
            
            transitionAnimator.onChangeInteractionState(shouldComplete ? .ended : .canceled)
        
        default:
            return
        }
    }
    
}
