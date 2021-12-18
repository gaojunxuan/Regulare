//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

protocol Stack {
    associatedtype Element
    
    mutating func push(_ item: Element)
    
    // allows discarding the result without generating a warning.
    @discardableResult
    mutating func pop() -> Element?
    
    func peek() -> Element?
    
    var count: Int { get }
}

extension Array: Stack {
    mutating func push(_ item: Element) {
        self.append(item)
    }
    
    mutating func pop() -> Element? {
        if let last = self.last {
            self.remove(at: self.count - 1)
            return last
        }
        
        return .none
    }
    
    func peek() -> Element? {
        self.last
    }
}
