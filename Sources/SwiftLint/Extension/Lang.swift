//
//  File.swift
//  
//
//  Created by gzhang on 2022/11/9.
//

import Foundation

public extension Optional {
    
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
    
    var isNil: Bool {  self == nil }
    var isNotNil: Bool { !isNil }
}

public extension CGFloat {
    var int: Int { Int(self) }
}

public extension Int {
    
    var cgfloat: CGFloat { CGFloat(self) }
    
    var double: Double { Double(self) }
    
    var int64: Int64 { Int64(self) }
    
    var int32: Int32 { Int32(self) }
    
    var date: Date{ Date(int: self) }
    
    func hexedString() -> String {
        return NSString(format: "%02x", self) as String
    }
    
    func lpad(_ length: Int, char: String = "0") -> String {
        var a = log10(self.cgfloat).int + 1
        var result = self.description
        while a < length && length > 1 {
            result = "\(char)\(result)"
            a = a + 1
        }
        return result
    }
    
}

public extension Double {
    
    var int: Int { Int(self) }
    
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
