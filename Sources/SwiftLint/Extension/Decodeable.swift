//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/30.
//

import Foundation

public extension Decodable{
    
    static func fromJSON(with str: String) -> Self? {
        
        if let data = str.data(using: .utf8) {
            if let decoded = try? JSONDecoder().decode(self.self, from: data) {
                return decoded
            }
        }
        return nil
    }
}
