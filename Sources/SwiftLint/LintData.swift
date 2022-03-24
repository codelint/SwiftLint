//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/24.
//

import Foundation

protocol LintDataSourceProtocol {
    
    func set<Value: Encodable>(_ k: String, with v: Value?)
    
    func get<Value: Decodable>(_ k: String) -> Value?
    
}

open class LintData: LintDataSourceProtocol {
    
    class StandardData: LintDataSourceProtocol {
        func set<Value: Encodable>(_ k: String, with v: Value?){
            if let encoded = try? JSONEncoder().encode(v) {
                // self.set(k, with: encoded)
                UserDefaults.standard.set(encoded, forKey: k)
                UserDefaults.standard.synchronize()
            }
        }
        
        func get<Value: Decodable>(_ k: String) -> Value?{
            if let data = UserDefaults.standard.data(forKey: k) {
                if let decoded = try? JSONDecoder().decode(Value.self, from: data) {
                    return decoded
                }
            }
            return nil
        }
    }
    
    static var s = LintData()
    
    let source: LintDataSourceProtocol
    
    let prefix: String
    
    init(prefix pfx: String = "swiftlint", source src: LintDataSourceProtocol? = nil) {
        self.prefix = pfx
        
        self.source = (src == nil) ? StandardData() : src!
    }
    
    func set<Value: Encodable>(_ k: String, with v: Value?){
        return source.set(k, with: v)
    }
    
    func get<Value: Decodable>(_ k: String) -> Value?{
        return source.get(k)
    }
    
    subscript<Value: Codable>(index: String) -> Value? {
        get {
            return self.get(index)
        }
        
        set {
            self.set(index, with: newValue)
        }
    }
    
    subscript<Value: Codable>(index: Key) -> Value? {
        get {
            return self.get("\(prefix).\(index.rawValue)")
        }
        
        set {
            self.set("\(prefix).\(index.rawValue)", with: newValue)
        }
    }
    
    func set<Value: Encodable>(for k: Key, with v: Value?){
        self.set(k.rawValue, with: v)
    }
    
    func get<Value: Decodable>(for k: Key) -> Value?{
        return self.get(k.rawValue)
    }
    
    enum Key: String {
        case name, email, phone, password, create_time, update_time
    }
}
