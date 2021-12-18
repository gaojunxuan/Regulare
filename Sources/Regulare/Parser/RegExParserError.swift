//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

/**
 Error when parsing the regular expression
 */
public class RegExParserError: RegExError {
    internal enum ParserErrorReason: String {
        case emptyOperatorStack = "Empty operator stack."
        case emptyOperandStack = "Empty operand stack."
        case invalidASTNode = "Invalid AST Node."
        case invalidPrecedence = "Invalid precedence definition."
        case failedASTNodeCreation = "Failed to create AST Node. Make sure the input token is valid."
    }
    
    internal init(_ reason: ParserErrorReason) {
        let message = "Error during parsing. " + reason.rawValue
        super.init(message)
    }
}
