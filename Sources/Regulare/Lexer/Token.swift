//
//  Token.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation


/// Type of token
public enum TokenType {
    /// Empty string
    case epsilon
    /// Character
    case char
    /// Quantifier: `*` and  `+`
    case quantifier
    /// Operator
    case op
    /// Left delimiter
    case leftDelimiter
    /// Right delimiter
    case rightDelimiter
    /// Unknown token
    case unknown
}

/// Defines a token (lexical unit) for regular expressions
public struct Token: Hashable {
    public let tag: TokenType
    public let value: Character
    
    private static let LEFT: Set<Character> = ["(", "[", "{"]
    private static let RIGHT: Set<Character> = [")", "]", "}"]
    private static let OP: Set<Character> = ["|"]
    private static let QUANT: Set<Character> = ["*", "+", "?"]
    
    /// Kleene star operator
    public static let star: Token = Token(tokenType: .quantifier, tokenVal: "*")
    /// Kleene plus operator
    public static let plus: Token = Token(tokenType: .quantifier, tokenVal: "+")
    /// Union operator
    public static let union: Token = Token(tokenType: .op, tokenVal: "|")
    /// Concatenation operator
    public static let concat: Token = Token(tokenType: .op, tokenVal: ".")
    
    /// Create a new token
    private init(tokenType: TokenType, tokenVal: Character) {
        self.tag = tokenType
        self.value = tokenVal
    }
    
    public static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.tag == rhs.tag && lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    /// Create a new token based on the given character
    public static func createToken(input: Character) -> Token {
        if (LEFT.contains(input)) {
            return Token(tokenType: .leftDelimiter, tokenVal: input)
        } else if (RIGHT.contains(input)) {
            return Token(tokenType: .rightDelimiter, tokenVal: input)
        } else if (OP.contains(input)) {
            return Token(tokenType: .op, tokenVal: input)
        } else if (QUANT.contains(input)) {
            return Token(tokenType: .quantifier, tokenVal: input)
        }
        return Token(tokenType: .char, tokenVal: input)
    }
    
    public static func createConcatToken() -> Token {
        return concat
    }
}
