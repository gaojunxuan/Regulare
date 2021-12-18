//
//  File.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

/// An AST Unit
protocol ASTNode {
    /// Left child
    var left: ASTNode? { get }
    /// Right child
    var right: ASTNode? { get }
    /// Expression
    var exp: ASTNode? { get }
    /// Operator
    var op: Lexer.Token { get }
}
