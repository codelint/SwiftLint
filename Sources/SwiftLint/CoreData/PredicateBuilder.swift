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
        case IN, NULL, BETWEEN, HAS, ANY, ANYIN
        case NOTIN = "NOT IN"
        case NOTBETWEEN = "NOT BETWEEN"
        case CONTAIN = "CONTAINS"
        case NEQ = "!="
        case EQ = "=="
        case LE = "<"
        case LT = "<="
        case GT = ">"
        case GE = ">="
        case SUB = "SUB"
    }

    var connector: String
    var wheres: [(String, Operation, Value)]
    
    public init(){
        self.wheres = []
        self.connector = "&&"
    }
    
    public func union() -> Self {
        self.connector = "||"
        return self
    }
    
    public func add(is field: String) -> Self {
        self.add(field, value: .init(true))
    }
    
    public func add(not field: String) -> Self {
        self.add(field, value: .init(false))
    }
    
    public func add(_ field: String, operation: Operation, value: Value) -> Self
    {
        self.wheres.append((field, operation, value))
        return self
    }
    
    public func add(_ field: String, a: any Numeric, b: any Numeric) -> Self
    {
        self.wheres.append((field, .BETWEEN, Value([a,b])))
        return self
    }
    
    public func add(_ field: String, operation: Operation, value: String?)  -> Self
    {
        return self.add(field, operation: operation, value: Value(value))
    }
    
    public func add(_ field: String, value: Value) -> Self
    {
        return self.add(field, operation: .EQ, value: value)
    }
    
    public func add(_ field: String, _ value: String?) -> Self
    {
        return self.add(field, value: .init(value))
    }
    
    public func add(_ field: String, _ value: UUID?) -> Self
    {
        return self.add(field, value: .init(value))
    }
    
    public func add(_ wheres: [String: String?]) -> Self
    {
        for (k, v) in wheres {
            _ = self.add(k, operation: .EQ, value: Value(v))
        }
        return self
    }
    
    public func add(_ wheres: [String: Value]) -> Self
    {
        for (k, v) in wheres {
            _ = self.add(k, operation: .EQ, value: v)
        }
        
        return self
    }
    
    public func whereContain(_ field: String, _ text: String) -> Self {
        return self.add(field, operation: .CONTAIN, value: .init(text))
    }
    
    public func whereNull(_ field: String) -> Self
    {
        return self.add(field, operation: .NULL, value: .init(true))
    }
    
    public func whereNotNull(_ field: String) -> Self
    {
        return self.add(field, operation: .NULL, value: .init(false))
    }
    
    public func whereIn(_ field: String, vars: [Value]) -> Self
    {
        return self.add(field, operation: .IN, value: .init(vars: vars))
    }
    
    public func whereNotIn(_ field: String, vars: [Value]) -> Self
    {
        return self.add(field, operation: .NOTIN, value: .init(vars: vars))
    }
    
    public func whereBetween<Number: Numeric>(_ field: String, a: Number, b: Number) -> Self
    {
        return self.add(field, operation: .BETWEEN, value: .init([a, b]))
    }
    
    public func whereNotBetween<Number: Numeric>(_ field: String, a: Number, b: Number) -> Self
    {
        return self.add(field, operation: .NOTBETWEEN, value: .init([a, b]))
    }
    
    public func whereSub(_ build: (PredicateBuilder) -> PredicateBuilder) -> Self{
        return self.add("##\(wheres.count)##", operation: .SUB, value: build(PredicateBuilder()).expression())
    }
    
    public func expression() -> String {
        let predicate_str = self.wheres.map({ (kov: (field: String, op: Operation, value: Value)) -> String in
            switch kov.op {
            case .EQ, .LE, .GE, .GT, .LT, .NEQ:
                return "\(kov.field) \(kov.op.rawValue) \(kov.value.description)"
            case .NULL:
                return "\(kov.field)\(kov.value.bool ?? true ? " == " : " != ")nil"
            case .IN:
                return "\(kov.field) IN {\(kov.value.vars.map({$0.description}).joined(separator: ","))}"
            case .NOTIN:
                return "\(kov.field) NOT IN {\(kov.value.vars.map({$0.description}).joined(separator: ","))}"
            case .NOTBETWEEN:
                return "(\(kov.field) < \(kov.value.numbers[0]) || \(kov.field) > \(kov.value.numbers[1]))"
            case .BETWEEN:
                return "\(kov.field) BETWEEN {\(kov.value.numbers[0]),\(kov.value.numbers[1])}"
            case .SUB:
                // field is unused here...
                return kov.value.str == nil ? "" : "( \(kov.value.str!) )"
            case .CONTAIN:
                return "\(kov.field) CONTAINS \(kov.value.description)"
            case .ANY, .HAS:
                return "ANY \(kov.field) = \(kov.value.description)"
            case .ANYIN:
                return "ANY \(kov.field) IN {\(kov.value.vars.map({$0.description}).joined(separator: ","))}"
            }
        }).filter({ str in
            return str.count > 0
        }).joined(separator: " \(connector) ")
        
        return predicate_str
    }
    
    public func predicate() -> NSPredicate? {
        let exp = expression()
        return exp.count > 0 ? NSPredicate(format: expression()) : nil
    }
}
