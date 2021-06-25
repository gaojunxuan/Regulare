//
//  File.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

struct LexerError: Error, LocalizedError {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        "Lexer error: \(message)"
    }
}

struct ParserError: Error, LocalizedError {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        "Parser error: \(message)"
    }
}
