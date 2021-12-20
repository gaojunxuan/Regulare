//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/20/21.
//

import Foundation

public struct NFABuilder {
    public private(set) var nfa: NFA
    
    public mutating func reset() {
        self.nfa = NFA()
    }
    
    public init() {
        self.nfa = NFA()
    }
    
    public func setStartState(idx: Int) throws {
        if (idx < 0 || idx >= self.nfa.states.count) {
            throw RegExError("Invalid NFA state index")
        }
        self.nfa.startState = self.nfa.states[idx]
    }
    
    public func setAcceptingState(idx: Int) throws {
        if (idx < 0 || idx >= self.nfa.states.count) {
            throw RegExError("Invalid NFA state index")
        }
        self.nfa.endState = self.nfa.states[idx]
    }
    
    public func addState() -> Int {
        let newIdx = self.nfa.states.count
        let newState = NFAState()
        self.nfa.states.append(newState)
        return newIdx
    }
    
    public func addTransition(from: Int, str: String, to: Int) throws {
        if (from < 0 || from >= self.nfa.states.count) {
            throw RegExError("Invalid NFA state index")
        }
        if (to < 0 || to >= self.nfa.states.count) {
            throw RegExError("Invalid NFA state index")
        }
        self.nfa.alphabets.insert(str)
        let fromState: NFAState = self.nfa.states[from]
        let toState: NFAState = self.nfa.states[to]
        fromState.addTransition(str: str, toState: toState)
    }
    
    public func addTransition(from: Int, str: String, to: NFA) throws {
        if to.isEmpty {
            throw RegExError("Empty NFA")
        }
        if (from < 0 || from >= self.nfa.states.count) {
            throw RegExError("Invalid NFA state index")
        }
        self.nfa.alphabets.insert(str)
        self.nfa.alphabets = self.nfa.alphabets.union(to.alphabets)
        let fromState = self.nfa.states[from]
        
        for state in to.states {
            if (!self.nfa.states.contains(state)) {
                self.nfa.states.append(state)
            }
        }
        fromState.addTransition(str: str, toState: to.startState!)
    }
    
    public func addTransition(from: NFA, str: String, to: Int) throws {
        if from.isEmpty {
            throw RegExError("Empty NFA")
        }
        if (to < 0 || to >= self.nfa.states.count) {
            throw RegExError("Invalid NFA state index")
        }
        self.nfa.alphabets.insert(str)
        self.nfa.alphabets = self.nfa.alphabets.union(from.alphabets)
        let toState = self.nfa.states[to]
        
        for state in from.states {
            if (!self.nfa.states.contains(state)) {
                self.nfa.states.append(state)
            }
        }
        from.endState!.addTransition(str: str, toState: toState)
    }
    
    public func addTransition(from: NFA, str: String, to: NFA) throws {
        if (from.isEmpty || to.isEmpty) {
            throw RegExError("Empty NFA")
        }
        self.nfa.alphabets.insert(str)
        self.nfa.alphabets = self.nfa.alphabets.union(from.alphabets)
        self.nfa.alphabets = self.nfa.alphabets.union(to.alphabets)
        for state in from.states + to.states {
            if (!self.nfa.states.contains(state)) {
                self.nfa.states.append(state)
            }
        }
        from.endState!.addTransition(str: str, toState: to.startState!)
    }
    
    public static func wildcard() throws -> NFA {
        let builder = NFABuilder()
        let startIdx = builder.addState()
        try builder.setStartState(idx: startIdx)
        try builder.setAcceptingState(idx: startIdx)
        return builder.nfa
    }
}
