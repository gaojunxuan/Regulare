//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

extension Parser {
    public class AlternationNode: ASTNode {
        /**
         Create a new alternation node.
         
         - Parameters: `left` the left child, `right` the right child
         - Invariant: `left` and `right` are not `nil`
         */
        internal init(left: ASTNode, right: ASTNode) {
            let op = Token.createToken(input: "|")
            super.init(left: left, right: right, op: op, exp: nil)
        }
        
        override public func getChildren() -> Array<Parser.ASTNode> {
            return [self.left!, self.right!]
        }
    }
}
