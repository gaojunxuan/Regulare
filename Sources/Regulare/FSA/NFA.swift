//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

postfix operator *
postfix operator +
postfix operator ¿

public class NFAState: FSAState, Hashable {
    private var transitionTable: Dictionary<String, Set<NFAState>> = [:]
    
    public init(_ tr: Dictionary<String, Set<NFAState>> = [:]) {
        self.transitionTable = tr
    }
    
    /**
     Return the resulting set of states given the string
     
     - Parameters: the input string
     - Returns: the set of states after reading the string
     */
    public func transition(str: String) -> Set<NFAState> {
        return self.transitionTable[str] ?? []
    }
    
    /**
     Add a transition to this `NFAState`
     
     - Parameters: input string for the transition function to be added
     */
    public func addTransition(str: String, toState: NFAState) {
        if self.transitionTable[str] != nil {
            self.transitionTable[str]?.insert(toState)
        } else {
            let newSet: Set<NFAState> = Set([toState])
            self.transitionTable[str] = newSet
        }
    }
    
    public static func == (lhs: NFAState, rhs: NFAState) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
        hasher.combine(self.transitionTable)
    }
}

public class NFA: FSA {
    
    public var states: Array<NFAState>
    public var startState: NFAState?
    public var endState: NFAState?
    public var alphabets: Set<String>
    public var acceptingStates: Set<NFAState?> {
        get {
            return Set([endState])
        }
    }
    
    public init() {
        self.states = []
        self.alphabets = []
        self.startState = nil
        self.endState = nil
    }
    
    /**
     Consume (transition on) the given character and returns the set of states reached after reading the character.
     
     - Parameters:
        - `from` the state to transition from
        - `str` the string representation of the character to be consumed
     - Returns: the states reached after reading the given string
     - Remark: typically, `str` should be a character, unless it is a special character such as `epsilon`
     */
    public func transition(from state: NFAState, str: String) -> Set<NFAState> {
        return state.transition(str: str)
    }
    
    /**
     Get the set of states reachable via epsilon transition
     
     - Parameters: the state to transition from
     - Returns: the set of states reachable via epsilon transition
     */
    public func reachableViaEpsilon(from state: NFAState) throws -> Set<NFAState> {
        var reachable: Set<NFAState> = []
        // perform DFS
        var stateStack: Array<NFAState> = []
        stateStack.push(state)
        while (!stateStack.isEmpty) {
            guard let top = stateStack.pop() else {
                throw RegExError("NFA error")
            }
            if (!reachable.contains(top)) {
                // set of states immediately reachable via epsilon-transition
                let epsilonStates: Set<NFAState> = self.transition(from: top, str: "epsilon")
                reachable.insert(top)
                for state in epsilonStates {
                    stateStack.push(state)
                }
            }
        }
        return reachable
    }
    
    /**
     Consume a string and return the set of states reached
     
     - Parameters:
        - `from` the state to transition from
        - `str` the string to be consumed
     - Returns: the states reached after reading the given string
     - Remark: `str` should be a string. If `str` is a character, the effect will be the same as running `transition`
     */
    public func extendedTransition(from state: NFAState, str: String) throws -> Set<NFAState> {
        var currStates: Set<NFAState> = try self.reachableViaEpsilon(from: state)
        // read the string in order
        for c in str {
            var reached: Set<NFAState> = []
            for fromState in currStates {
                // all states reachable after reading the current character
                let reachable: Set<NFAState> = self.transition(from: fromState, str: String(c))
                for toState in reachable {
                    // add the states reachable via epsilon transition
                    let epsilonStates = try self.reachableViaEpsilon(from: toState)
                    reached = reached.union(epsilonStates)
                }
            }
            // for next iteration, starts from states currently reached
            currStates = reached
        }
        return currStates
    }
    
    /**
     Determine whether or not the given string is accepted by this NFA
     
     - Parameters: the input string
     */
    public func accept(str: String) -> Bool {
        do {
            if (!self.isEmpty) {
                return try self.extendedTransition(from: self.startState!, str: str).contains(self.endState!)
            }
            else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public var isEmpty: Bool {
        get {
            return startState == nil && endState == nil
        }
    }
    
    public static func + (lhs: NFA, rhs: NFA) throws -> NFA {
        let builder = NFABuilder()
        let startIdx = builder.addState()
        
        try builder.setStartState(idx: startIdx)
        
        try builder.addTransition(from: startIdx, str: "epsilon", to: lhs)
        try builder.addTransition(from: lhs, str: "epsilon", to: rhs)
        
        let endIdx = builder.addState()
        try builder.setAcceptingState(idx: endIdx)
        
        try builder.addTransition(from: rhs, str: "epsilon", to: endIdx)
        return builder.nfa
    }
    
    public static postfix func * (lhs: NFA) throws -> NFA {
        let builder = NFABuilder()
        let startIdx = builder.addState()
        try builder.setStartState(idx: startIdx)
        try builder.setAcceptingState(idx: startIdx)
        
        try builder.addTransition(from: startIdx, str: "epsilon", to: lhs)
        try builder.addTransition(from: lhs, str: "epsilon", to: startIdx)
        return builder.nfa
    }
    
    public static postfix func + (lhs: NFA) throws -> NFA {
        let nfaStar = try lhs*
        return try lhs + nfaStar
    }
    
    public static postfix func ¿ (lhs: NFA) throws -> NFA {
        let wc: NFA = try NFABuilder.wildcard()
        return try lhs | wc
    }
    
    public static func | (lhs: NFA, rhs: NFA) throws -> NFA {
        let builder = NFABuilder()
        let startIdx = builder.addState()
        try builder.setStartState(idx: startIdx)
        
        try builder.addTransition(from: startIdx, str: "epsilon", to: lhs)
        try builder.addTransition(from: startIdx, str: "epsilon", to: rhs)
        
        let endIdx = builder.addState()
        try builder.setAcceptingState(idx: endIdx)
        
        try builder.addTransition(from: lhs, str: "epsilon", to: endIdx)
        try builder.addTransition(from: rhs, str: "epsilon", to: endIdx)
        return builder.nfa
    }
}
