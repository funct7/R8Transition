//
//  UIViewControllerContextTransitioning+Extension.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import UIKit

extension UIViewControllerContextTransitioning {
    
    /// The transitioned view controller. (i.e. the "object" of transition)
    var objectVC: UIViewController? {
        guard let toVC = viewController(forKey: .to) else { return nil }
        return toVC.isBeingPresented ? toVC : viewController(forKey: .from)
    }
    
    var transitionDidComplete: Bool { !transitionWasCancelled }
    
}
