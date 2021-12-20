//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

protocol FSA {
    associatedtype T: Hashable
    associatedtype S
    var states: Array<T> { get set }
    var alphabets: Set<String> { get set }
    var startState: T? { get set }
    
    func transition(from state: T, str: String) -> S
    func accept(str: String) -> Bool
}

protocol FSAState {
    associatedtype T
    func transition(str: String) -> T
}
