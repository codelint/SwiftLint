//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/26.
//

import Foundation

public extension Encodable{
    var stringified: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
