//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import Foundation

extension Int {
    
    func hexedString() -> String {
        return NSString(format: "%02x", self) as String
    }
    
}
