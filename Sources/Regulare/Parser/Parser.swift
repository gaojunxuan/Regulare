//
//  File.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

struct Parser {
    private let PREC: Dictionary<Character, Int> = [
        "?": 3,
        "+": 3,
        "*": 3,
        ".": 2,
        "|": 1
    ]
    private var tokens: Array<Token>
    
    public init(_ tokens: Array<Token>) {
        self.tokens = tokens
    }
    
    /**
     Parse the tokens into an abstract syntax tree.
     
     - Throws: `RegExParserError` when either the operator stack or the operand stack becomes
                empty before the algorithm finishes processing the all tokens. It may also throw this error
                when th algorithm is not able to create an `ASTNode` associated with the token being
                read. This is usually due to an unsupported type of token.
     - Returns: an `ASTNode` that is the root of the abstract syntax tree
     */
    public func parse() throws -> ASTNode {
        // operator and operand stack
        var op: Array<Token> = []
        var operand: Array<ASTNode> = []
        // Read the tokens sequentially and construct the AST similar
        // to the process of converting an expression into Reversed Polish Notation
        for currToken in self.tokens {
            if (currToken.tag == TokenType.leftDelimiter) {
                if (currToken.value == "(") {
                    op.push(currToken)
                }
            } else if (currToken.tag == TokenType.rightDelimiter) {
                if (currToken.value == ")") {
                    guard var opTop = op.pop() else {
                        throw RegExParserError(.emptyOperatorStack)
                    }
                    // Keep popping from the operator stack until an open parenthesis is found
                    while (opTop.value != "(" && !op.isEmpty) {
                        guard let astNode: ASTNode = Parser.createASTNode(op: opTop, operandStack: &operand) else {
                            throw RegExParserError(.failedASTNodeCreation)
                        }
                        operand.push(astNode)
                        if let t = op.pop() {
                            opTop = t
                        } else {
                            throw RegExParserError(.emptyOperatorStack)
                        }
                        
                    }
                }
            } else if (currToken.tag == TokenType.quantifier || currToken.tag == TokenType.op) {
                while (!op.isEmpty) {
                    guard let opTop = op.pop() else {
                        throw RegExParserError(.emptyOperatorStack)
                    }
                    if (opTop.value != "(" && ((PREC[currToken.value] ?? 100) <= (PREC[opTop.value] ?? -1))) {
                        guard let astNode: ASTNode = Parser.createASTNode(op: opTop, operandStack: &operand) else {
                            throw RegExParserError(.failedASTNodeCreation)
                        }
                        operand.push(astNode)
                    } else {
                        op.push(opTop)
                        break
                    }
                }
                op.push(currToken)
            } else if (currToken.tag == TokenType.char) {
                operand.push(CharNode(literal: currToken.value))
            }
        }
        // Output the remaining operands
        while (!op.isEmpty) {
            guard let opTop = op.pop() else {
                throw RegExParserError(.emptyOperatorStack)
            }
            guard let astNode: ASTNode = Parser.createASTNode(op: opTop, operandStack: &operand) else {
                throw RegExParserError(.emptyOperatorStack)
            }
            operand.push(astNode)
        }
        guard let operandTop = operand.pop() else {
            throw RegExParserError(.emptyOperandStack)
        }
        return operandTop
    }
}
