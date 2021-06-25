//
//  File.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

/// An AST Unit
protocol ASTUnit {}

/// A composite AST containing multiple AST units
protocol AST {
    var children: [ASTUnit] { get }
}
