//
//  Lexer.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation


/// A lexer (lexical analyzer) for regular expressions
public class Lexer {
    public private(set) var tokens: Array<Token> = []
    private var index: Int = 0
    public let input: String
    
    init(_ input: String) {
        self.input = input
    }
    
    /**
     Tokenize the input string
     
     - Throws: `RegExSyntaxError` if there are unmatched delimiters
     */
    public func tokenize() throws {
        var inputStack: Array<Token> = []
        for i in 0...self.input.count - 1 {
            let currToken: Token = Token.createToken(input: self.input[i])
            switch currToken.tag {
            case .leftDelimiter:
                inputStack.push(currToken)
                self.tokens.append(currToken)
            case .rightDelimiter:
                if inputStack.isEmpty {
                    throw RegExSyntaxError(i)
                } else {
                    let top: Character = inputStack.pop()?.value ?? " "
                    if top == "(" {
                        if self.input[i] != ")" {
                            throw RegExSyntaxError(i)
                        }
                        self.tokens.append(currToken)
                    } else if top == "[" {
                        if self.input[i] != "]" {
                            throw RegExSyntaxError(i)
                        }
                        self.tokens.append(currToken)
                    } else if top == "{" {
                        if self.input[i] != "}" {
                            throw RegExSyntaxError(i)
                        }
                        self.tokens.append(currToken)
                    }
                    
                }
            default:
                self.tokens.append(currToken)
            }
            if (i == self.input.count - 1 && !inputStack.isEmpty) {
                throw RegExSyntaxError(i)
            }
            
        }
        self.insertConcat()
    }
    /**
     Insert the concatenation operators
                    
     The concatenation operator is inserted in the following cases:
 
     1.  closure and something that is not right parentheses, operator, or closure
     2.  pair of characters
     3.  character and left parentheses
     4.  right parentheses and character
     5.  right parentheses and left parentheses
              
     - Example: For example, an expression of "(ab*)+c*|d" will become "(a.b*)+.c*|d" after the insertions.
    */
    private func insertConcat() {
        for i in stride(from: self.tokens.count - 1, to: 0, by: -1) {
            let right: TokenType = self.tokens[i].tag
            let left: TokenType = self.tokens[i-1].tag
            if (left == .quantifier && !(right == .rightDelimiter || right == .op || right == .quantifier)) {
                self.tokens.insert(Token.createConcatToken(), at: i)
            } else if (right == .char || right == .leftDelimiter) {
                if (left == .char || left == .rightDelimiter) {
                    tokens.insert(Token.createConcatToken(), at: i)
                }
            }
        }
    }
}

