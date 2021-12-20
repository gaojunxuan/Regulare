//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/20/21.
//

import XCTest
@testable import Regulare

var builder: NFABuilder = NFABuilder()
var nfa1: NFA = NFA()
var nfa2: NFA = NFA()

final class NFATests: XCTestCase {
    
    override func setUp() {
        builder = NFABuilder()
        builder.reset();
        do {
            let state1 = builder.addState();
            let state2 = builder.addState()
            try builder.addTransition(from: state1, str: "a", to: state2)
            try builder.setStartState(idx: state1)
            try builder.setAcceptingState(idx: state2)
            nfa1 = builder.nfa  // this NFA accepts "a"

            builder.reset()
            let state3 = builder.addState()
            let state4 = builder.addState()
            try builder.addTransition(from: state3, str: "b", to: state4)
            try builder.setStartState(idx: state3);
            try builder.setAcceptingState(idx: state4);
            nfa2 = builder.nfa;  // this NFA accepts "b"
        } catch {
            XCTFail()
        }
        
    }
    func testNFAOperation() {
        do {
            let expected: NFA = try nfa1 | nfa2
            XCTAssert(expected.accept(str: "a"))
            XCTAssert(expected.accept(str: "b"))
            XCTAssertFalse(expected.accept(str: "ab"))
        } catch {
            XCTFail()
        }
    }
}
