//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import Foundation
// import CommonCrypto
import CryptoKit

public extension String {
    
    func ends(with: String) -> Bool {
        return self.hasSuffix(with)
    }
    
    func ends(with: [String]) -> Bool {
        for w in with {
            if self.hasSuffix(w){
                return true
            }
        }
        return false
    }
    
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
    
    func replace(search pattern: String, with newOne: String, count: Int? = nil) -> String {
        if let regex = try? NSRegularExpression(
            pattern: pattern,
            options: []
        ) {
            
            return regex.stringByReplacingMatches(in: self, range: NSRange(0..<self.count), withTemplate: newOne)
        }
        return self
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
        return Insecure.MD5
            .hash(data: self.data(using: .utf8)!)
            .map {String(format: "%02x", $0)}
            .joined()
    }

    func substr(start: Int = 0, length: Int = 0) -> String {
        var str = self
        let max = str.count
        let startIdx = start < 0 ? 0 : start
        if max == 0 || startIdx > max - 1{
            return ""
        }
        let endIdx = length + start - 1
        // endIdx = endIdx < max ? endIdx : max - 1
        let si = str.index(str.startIndex, offsetBy: startIdx)
        if endIdx >= startIdx && endIdx < max {
            let ei = str.index(str.startIndex, offsetBy: endIdx)
            str = String(str[si...ei])
        }else{
            str = String(str[si...])
        }
        return str
    }
    
    // url encode / decode
    func urlEncoded() -> String {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: "!*'\"();:@&=+$,/?%#[]% ")
        
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
        return encodeUrlString ?? ""
    }
    
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }

    
    // unicode
    func unicodeEncode() -> String {
        var str: String = ""
        
        for scalar in self.unicodeScalars {
            str += String(format: "\\u%04lX", scalar.value)
        }
        
        return str
    }
    
    func unicodeDecode() -> String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr: String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
}

