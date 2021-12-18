//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

extension Parser {
    /**
     A character node.
     */
    public class CharNode: ASTNode {
        let literal: Character
        
        internal init(literal: Character) {
            self.literal = literal
            super.init(left: nil, right: nil, op: Token.createToken(input: literal), exp: nil)
        }
    }
}
