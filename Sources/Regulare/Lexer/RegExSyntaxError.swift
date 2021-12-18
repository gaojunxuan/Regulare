//
//  File.swift
//  
//
//  Created by Kevin Gao on 12/18/21.
//

import Foundation

public class RegExSyntaxError: RegExError {
    let index: Int
    
    internal init(_ index: Int) {
        self.index = index
        super.init("Syntax error at \(index)")
    }
    
    public override var localizedDescription: String {
        return message
    }
}
