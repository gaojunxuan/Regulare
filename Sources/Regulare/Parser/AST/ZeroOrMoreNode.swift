//
//  File.swift
//
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

extension Parser {
    /**
     A Kleene star node
     */
    public class ZeroOrMoreNode: ASTNode {
        /**
         Create a new Kleene star closure node.
         
         - Parameters: `exp` the quantified expression
         - Invariant: `exp` is not `nil`, `left`and `right` are `nil`
         */
        internal init(exp: ASTNode) {
            let op = Token.createToken(input: "*")
            super.init(left: nil, right: nil, op: op, exp: exp)
        }
        
        override public func getChildren() -> Array<Parser.ASTNode> {
            return [self.exp!]
        }
    }
}
