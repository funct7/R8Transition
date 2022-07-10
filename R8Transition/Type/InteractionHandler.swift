//
//  InteractionHandler.swift
//  Pods-R8Transition_Example
//
//  Created by Josh Woomin Park on 2022/07/10.
//

import Foundation

/**
 An interface for objects that will update the interactive transition.
 */
public protocol InteractionHandler {
    
    func onChangeInteractionState(_ state: InteractionState)

}

public enum InteractionState : Equatable {
    case began
    /// Associated value: the completion percentage of transition. (range: `0.0 ... 1.0`)
    case changed(Double)
    case ended
    case canceled
}
