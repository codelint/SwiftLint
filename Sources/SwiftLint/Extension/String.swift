//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import Foundation

public extension String {
    func starts(with: [String]) -> Bool {
        for w in with {
            if self.starts(with: w) {
                return true
            }
        }
        return false
    }
    
    func match(regex: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return pre.evaluate(with: self);
    }
}
