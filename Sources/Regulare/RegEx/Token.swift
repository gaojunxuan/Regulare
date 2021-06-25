//
//  Token.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

extension RegEx {
    /// Type of token
    public enum TokenType {
        /// Empty string
        case lambda
        /// Number
        case num
        /// String
        case str
        /// Quantifier: `*` and  `+`
        case quantifier
        /// Operator
        case op
        /// Delimiter: `()`, `{}`, and `[]`
        case delimiter
        /// Unknown token
        case unknown
    }

    /// Defines a token (lexical unit) for regular expressions
    public struct Token: Hashable {
        public let tag: TokenType
        public let value: String
        
        /// Kleene star operator
        public static let star: Token = Token(tag: .quantifier, value: "*")
        /// Union operator
        public static let union: Token = Token(tag: .op, value: "+")
        
        public static func == (lhs: Token, rhs: Token) -> Bool {
            return lhs.tag == rhs.tag && lhs.value == rhs.value
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }
}
