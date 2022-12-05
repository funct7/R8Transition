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
        FractionAnimationProviders.makeStandard(self) { vc, progress in
            vc.view.backgroundColor = UIColor(white: 0, alpha: 0.3 * progress)
            vc.bottomSheetBottomToViewBottom.constant = vc.bottomSheetView.frame.height * (1 - progress)
        }
    }
    
    @IBOutlet private var panGesture: UIPanGestureRecognizer!
    @IBOutlet private var panGestureHandler: PanGestureHandler!

    @IBOutlet private weak var bottomSheetView: UIView!
    
    @IBOutlet private var bottomSheetBottomToViewBottom: NSLayoutConstraint!
    
    @IBAction private func backgroundAction() {
        dismiss(animated: true)
    }
    
}
