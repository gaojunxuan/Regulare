//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

protocol FSA {
    associatedtype T: Hashable
    var states: Set<T> { get set }
    var alphabets: Set<String> { get set }
    var startState: T { get set }
    var acceptingStates: Set<T> { get set }
    
    func transition(from state: T, str: String) -> T
    func accept(str: String) -> Bool
}

protocol FSAState {
    func transition(str: String) -> FSAState
}
