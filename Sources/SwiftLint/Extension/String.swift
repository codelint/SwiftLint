//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import Foundation
import CommonCrypto

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
    
    /**
     * base64 string decode
     */
    func base64decode() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /**
     * encode the string to base64 string
     */
    func base64encode() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /**
     * generate md5 string
     */
    func md5() -> String {
        //todo
        return self
    }
    
}
