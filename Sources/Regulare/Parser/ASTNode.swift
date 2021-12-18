//
//  File.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

/// An AST Unit
extension Parser {
    public class ASTNode {
        /// Left child
        let left: ASTNode?
        /// Right child
        let right: ASTNode?
        /// Expression contained in the node
        let exp: ASTNode?
        /// Operation represented by the node
        let op: Token
        
        internal init(left: ASTNode?, right: ASTNode?, op: Token, exp: ASTNode?) {
            self.left = left
            self.right = right
            self.op = op
            self.exp = exp
        }
        
        public func getChildren() -> Array<ASTNode> {
            return []
        }
        
        public func astPrettyPrint(strIn: inout String, prefix: String, childrenPrefix: String) {
            strIn.append(prefix)
            strIn.append(String(describing: self))
            strIn.append("\t")
            if self.getChildren().isEmpty {
                if self is CharNode {
                    strIn.append((self as! CharNode).literal)
                    strIn.append("\n")
                }
            } else {
                strIn.append(self.op.value)
                strIn.append("\n")
                for i in 0...self.getChildren().count - 1 {
                    let nextNode: ASTNode = self.getChildren()[i]
                    if i < self.getChildren().count - 1 {
                        nextNode.astPrettyPrint(strIn: &strIn, prefix: childrenPrefix + "├── ", childrenPrefix: childrenPrefix + "│   ")
                    } else {
                        nextNode.astPrettyPrint(strIn: &strIn, prefix: childrenPrefix + "└── ", childrenPrefix: childrenPrefix + "    ")
                    }
                }
            }
        }
    }
    
    public static func createASTNode(op: Token, operandStack: inout Array<ASTNode>) -> ASTNode? {
        if (op.value == "|") {
            let left: ASTNode = operandStack.pop()!
            let right: ASTNode = operandStack.pop()!
            let alt: AlternationNode = AlternationNode(left: left, right: right)
            return alt
        } else if (op.value == ".") {
            let left: ASTNode = operandStack.pop()!
            let right: ASTNode = operandStack.pop()!
            let concat: ConcatenationNode = ConcatenationNode(left: left, right: right)
            return concat
        } else if (op.value == "*") {
            let exp: ASTNode = operandStack.pop()!
            let star: ZeroOrMoreNode = ZeroOrMoreNode(exp: exp)
            return star
        } else if (op.value == "+") {
            let exp: ASTNode = operandStack.pop()!
            let plus: OneOrMoreNode = OneOrMoreNode(exp: exp)
            return plus
        } else if (op.value == "?") {
            let exp: ASTNode = operandStack.pop()!
            let question: ZeroOrOneNode = ZeroOrOneNode(exp: exp)
            return question
        }
        return nil;
    }
}
