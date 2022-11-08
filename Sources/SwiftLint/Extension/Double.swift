//
//  Double.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

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
