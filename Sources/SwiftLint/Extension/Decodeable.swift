//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/30.
//

import Foundation

public extension Decodable{
    
    static func fromJSON(with str: String, using: String.Encoding = .utf8) -> Self? {
        
        if let data = str.data(using: using) {
            if let decoded = try? JSONDecoder().decode(self.self, from: data) {
                return decoded
            }
        }
        return nil
    }
    
    static func fromJSON(with data: Data?) -> Self? {
        
        if let data = data {
            if let decoded = try? JSONDecoder().decode(self.self, from: data) {
                return decoded
            }
        }
        return nil
    }
}
