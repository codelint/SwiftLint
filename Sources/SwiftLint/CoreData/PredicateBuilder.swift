//
//  File.swift
//  
//
//  Created by gzhang on 2022/11/8.
//

import Foundation

public class PredicateBuilder {
    
    public struct Value {
        var type: ValueType
        var str: String? = nil
        var int: Int? = nil
        var number: (any Numeric)? = nil
        var vars: [Value] = []
        var numbers: [any Numeric] = []
        var map: [String: Value] = [:]
        var bool: Bool? = nil
        
        public init(_ string: String?)
        {
            self.type = .string
            self.str = string
        }
        
        public init(_ numbers: [any Numeric])
        {
            self.type = .numbers
            self.numbers = numbers
        }
        
        public init(_ int: Int64)
        {
            self.type = .int
            self.int = Int(int)
        }
        
        public init(_ int: Int32)
        {
            self.type = .int
            self.int = Int(int)
        }
        
        public init(_ int: Int16)
        {
            self.type = .int
            self.int = Int(int)
        }
        
        public init(_ uuid: UUID?)
        {
            self.type = .string
            self.str = uuid?.description
        }
        
        public init(_ int: Int?)
        {
            self.type = .int
            self.int = int
        }
        
        public init(vars: [Value])
        {
            self.type = .vars
            self.vars = vars
        }
        
        public init(_ vars: [Value])
        {
            self.type = .vars
            self.vars = vars
        }
        
        public init(_ map: [String: Value])
        {
            self.type = .map
            self.map = map
        }
        
        public init (number: (any Numeric)?)
        {
            self.type = .number
            self.number = number
        }
        
        public init (_ bool: Bool)
        {
            self.type = .bool
            self.bool = bool
        }
        
        var description: String {
            switch self.type {
            case .int:
                return self.int == nil ? "nil" : "\(self.int!)"
            case .number:
                return self.number == nil ? "nil" : "\(self.number!)"
            case .string:
                return "'\(self.str ?? "")'"
            case .bool :
                return self.bool == nil ? "nil" : (self.bool! ? "YES" : "NO")
            case .map, .numbers, .vars:
                return ""
            }
        }
    }
    
    public enum ValueType: String {
        case int, string, vars, map, number, numbers, bool
    }
    
    public enum Operation: String {
        case IN, NULL, BETWEEN
        case NOTIN = "NOT IN"
        case NOTBETWEEN = "NOT BETWEEN"
        case NEQ = "!="
        case EQ = "=="
        case LE = "<"
        case LT = "<="
        case GT = ">"
        case GE = ">="
    }

    var wheres: [(String, Operation, Value)]
    
    public init(){
        self.wheres = []
    }
    
    public func add(is field: String) -> PredicateBuilder {
        self.add(field, value: .init(true))
    }
    
    public func add(not field: String) -> PredicateBuilder {
        self.add(field, value: .init(false))
    }
    
    public func add(_ field: String, operation: Operation, value: Value) -> PredicateBuilder
    {
        self.wheres.append((field, operation, value))
        return self
    }
    
    public func add(_ field: String, a: any Numeric, b: any Numeric) -> PredicateBuilder
    {
        self.wheres.append((field, .BETWEEN, Value([a,b])))
        return self
    }
    
    public func add(_ field: String, operation: Operation, value: String?)  -> PredicateBuilder
    {
        return self.add(field, operation: operation, value: Value(value))
    }
    
    public func add(_ field: String, value: Value) -> PredicateBuilder
    {
        return self.add(field, operation: .EQ, value: value)
    }
    
    public func add(_ field: String, _ value: String?) -> PredicateBuilder
    {
        return self.add(field, value: .init(value))
    }
    
    public func add(_ field: String, _ value: UUID?) -> PredicateBuilder
    {
        return self.add(field, value: .init(value))
    }
    
    public func add(_ wheres: [String: String?]) -> PredicateBuilder
    {
        for (k, v) in wheres {
            _ = self.add(k, operation: .EQ, value: Value(v))
        }
        return self
    }
    
    public func add(_ wheres: [String: Value]) -> PredicateBuilder
    {
        for (k, v) in wheres {
            _ = self.add(k, operation: .EQ, value: v)
        }
        
        return self
    }
    
    public func predicate() -> NSPredicate?
    {
        let predicate_str = self.wheres.map { (kov: (field: String, op: Operation, value: Value)) -> String in
            switch kov.op {
            case .EQ, .LE, .GE, .GT, .LT, .NEQ:
                return "\(kov.field) \(kov.op.rawValue) \(kov.value.description)"
            case .IN:
                return "\(kov.field) IN {\(kov.value.vars.map({$0.description}).joined(separator: ","))}"
            case .NULL:
                return "(\(kov.field)\(kov.value.bool ?? true ? "==" : "!=")nil"
            case .NOTIN:
                return "\(kov.field) NOT IN \(kov.value.numbers[0]),\(kov.value.numbers[1])"
            case .NOTBETWEEN:
                return "(\(kov.field) < \(kov.value.numbers[0]) || \(kov.field) > \(kov.value.numbers[1]))"
            case .BETWEEN:
                return "\(kov.field) BETWEEN {\(kov.value.numbers[0]),\(kov.value.numbers[1])}"
            }
        }.filter({ str in
            return str.count > 0
        }).joined(separator: " && ")
        
        // print(predicate_str)
        return NSPredicate(format: predicate_str)
    }
}
