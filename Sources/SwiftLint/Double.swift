//
//  Double.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

extension Double {
    static func randomColorRGB() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
}
