//
//  InteractionState+Extension.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import Foundation

public extension InteractionState {
    
    var isBegan: Bool {
        switch self {
        case .began: return true
        default: return false
        }
    }
    
    var isChanged: Bool {
        switch self {
        case .changed: return true
        default: return false
        }
    }
    
    var isEnded: Bool {
        switch self {
        case .ended: return true
        default: return false
        }
    }
    
    var isCanceled: Bool {
        switch self {
        case .canceled: return true
        default: return false
        }
    }
    
}
