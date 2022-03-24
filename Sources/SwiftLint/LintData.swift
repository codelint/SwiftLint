//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import Foundation

public protocol LintDataSourceProtocol {
    
    func set<Value: Encodable>(_ k: String, with v: Value?)
    
    func get<Value: Decodable>(_ k: String) -> Value?
    
}

open class LintData: LintDataSourceProtocol {
    
    public class StandardData: LintDataSourceProtocol {
        public func set<Value: Encodable>(_ k: String, with v: Value?){
            if let encoded = try? JSONEncoder().encode(v) {
                // self.set(k, with: encoded)
                UserDefaults.standard.set(encoded, forKey: k)
                UserDefaults.standard.synchronize()
            }
        }
        
        public func get<Value: Decodable>(_ k: String) -> Value?{
            if let data = UserDefaults.standard.data(forKey: k) {
                if let decoded = try? JSONDecoder().decode(Value.self, from: data) {
                    return decoded
                }
            }
            return nil
        }
    }
    
    public struct Key: Equatable {
        let rawValue: String
        public init(_ r: String ) {
            self.rawValue = r
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
    
    static var s = LintData()
    
    let source: LintDataSourceProtocol
    
    let prefix: String
    
    public init(prefix pfx: String = "swiftlint", source src: LintDataSourceProtocol? = nil) {
        self.prefix = pfx
        
        self.source = (src == nil) ? StandardData() : src!
    }
    
    public func set<Value: Encodable>(_ k: String, with v: Value?){
        return source.set(k, with: v)
    }
    
    public func get<Value: Decodable>(_ k: String) -> Value?{
        return source.get(k)
    }
    
    public subscript<Value: Codable>(index: String) -> Value? {
        get {
            return self.get(index)
        }
        
        set {
            self.set(index, with: newValue)
        }
    }
    
    public subscript<Value: Codable>(index: Key) -> Value? {
        get {
            return self.get("\(prefix).\(index.rawValue)")
        }
        
        set {
            self.set("\(prefix).\(index.rawValue)", with: newValue)
        }
    }
    
    public func set<Value: Encodable>(for k: Key, with v: Value?){
        self.set(k.rawValue, with: v)
    }
    
    public func get<Value: Decodable>(for k: Key) -> Value?{
        return self.get(k.rawValue)
    }

}
