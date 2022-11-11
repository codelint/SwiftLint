//
//  File.swift
//  
//
//  Created by gzhang on 2022/11/9.
//

import Foundation

extension Optional {
    
    func with(_ transform: @escaping (Wrapped) -> Void) {
        if let wrapped = self {
            transform(wrapped)
        }
    }
    
    func tap(_ transform: @escaping (Wrapped) -> Wrapped?) -> Self {
        if let wrapped = self {
            return transform(wrapped)
        }
        return nil
    }
}

extension Int {
    
    func hexedString() -> String {
        return NSString(format: "%02x", self) as String
    }
    
}

public extension Double {
    
    static func randomColorRGB() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
    
    // 取N位小数
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toFixed(_ p: Int) -> String {
        return String(format: "%.\(p)f", self)
    }

}
