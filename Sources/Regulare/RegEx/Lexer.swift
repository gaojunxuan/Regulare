//
//  Lexer.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

extension RegEx {
    /// A lexer (lexical analyzer) for regular expressions
    public class Lexer {
        private let words: Set<Token> = Set()
        private var index: Int = 0
        public let input: String
        
        init(_ input: String) {
            self.input = input
        }
        
        /// Read a token and return the corresponding `Token` object
        public func readToken() -> Token {
            // skip whitespaces
            while self.index < self.input.count {
                let current: Character = self.input[self.index]
                if current == " " {
                    self.index += 1
                }
                else {
                    break
                }
            }
            var buffer: String = ""
            if self.input[self.index].isNumber {
                repeat {
                    buffer.append(self.input[self.index])
                    self.index += 1
                }
                while self.index < self.input.count && self.input[self.index].isNumber
                let token = Token(tag: .num, value: buffer)
                return token
            }
            else if self.input[self.index].isLetter {
                repeat {
                    buffer.append(self.input[self.index])
                    self.index += 1
                }
                while self.index < self.input.count && self.input[self.index].isLetter
                let token = Token(tag: .str, value: buffer)
                return token
            }
            return Token(tag: .unknown, value: "")
        }
    }
}

