//
//  File.swift
//  
//
//  Created by Kevin Gao on 6/24/21.
//

import Foundation

public class RegExError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
