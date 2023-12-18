//
//  File.swift
//  
//
//  Created by gzhang on 2023/12/17.
//

import Foundation

open class LintExpression {
    
    let text: String
    var context: [String: Double] = [:]
    
    public init(_ text: String, context: [String: Double] = [:]) {
        // self.text = text
        var text = text
            .replace(search: "（", with: "(")
            .replace(search: "）", with: ")")
            .replace(search: "，", with: ",")
        if text.match(regex: "#[^#]{1,}#") {
            text = text.replace(search: "#", with: "").replace(search: "[a-zA-Z]{1,}", with: "#$0#")
        }
        
        text = text.split(separator: ",").map({ "(\($0.description))" }).joined(separator: "+")
        
        self.text = text
        self.context = context.reduce([:], { $0.add(key: $1.key.lowercased(), value: $1.value) })
    }
    
    public func split2tokens() -> [String] {
        let patterns = [
            "(#[a-zA-Z0-9]{1,}#)",
            "([\\(\\)\\+\\-\\*\\/\\%])",
            "([0-9]{1,}\\.[0-9]{1,})",
            "([0-9]{1,})"
        ]
        if let regex = try? NSRegularExpression(pattern: patterns.joined(separator: "|"), options: [
            .caseInsensitive, .useUnicodeWordBoundaries
        ]) {
            let matches = regex.matches(in: text, range: NSMakeRange(0, text.count))
            return matches.map({ NSString(string: text).substring(with: $0.range).description })
        }else{
            return []
        }
    }
    
    private func token2double(_ token: String) -> Double? {
        if token.match(regex: "(#[a-zA-Z0-9]{1,}#)") {
            return context[token.lowercased()] ?? 0.0
        }else{
            return Double(token)
        }
    }
    
    public func evaluate(_ defaults: Double) -> Double { evaluate() ?? defaults }
    
    public var int: Int? { evaluate()?.int }
    public var double: Double? { evaluate() }

    public func evaluate() -> Double? {
        var operandStack: [Double] = []
        var operatorStack: [Operator] = []
        
        func performOperation() -> Bool {
            if operatorStack.count == 0 || !Operator.calulators.contains(operatorStack.last!){
                return true
            }
            if let operatorValue = operatorStack.popLast() {
                if operatorStack.count == 0 || operatorStack.last == .left || operatorStack.last!.precedence < operatorValue.precedence {
                    guard let rightOperand = operandStack.popLast(), let leftOperand = operandStack.popLast() else { return false }
                    
                    if let result = operatorValue.apply(left: leftOperand, right: rightOperand) {
                        operandStack.append(result)
                        return true
                    }else{
                        return false
                    }
                }else{
                    guard let rightOperand = operandStack.popLast() else { return false }
                    if performOperation() {
                        guard let leftOperand = operandStack.popLast() else { return false }
                        
                        if let result = operatorValue.apply(left: leftOperand, right: rightOperand) {
                            operandStack.append(result)
                            return true
                        }else{
                            return false
                        }
                    }else{
                        return false
                    }
                }
            }
            else{
                return true
            }
        }
        
        for token in split2tokens() {
            if let number = token2double(token) {
                operandStack.append(number)
            } else if let operatorValue = Operator(rawValue: String(token)) {
                switch operatorValue {
                case .left:
                    operatorStack.append(.left)
                case .right:
                    while operatorStack.count > 0 && Operator.calulators.contains(operatorStack.last!) {
                        if !performOperation() {
                            return nil
                        }
                    }
                    if let last = operatorStack.last, last == .left {
                        operatorStack.removeLast()
                    }
                case .minus:
                    fallthrough
                case .plus:
                    if operandStack.count == 0 {
                        operandStack.append(0.0)
                    }
                    fallthrough
                default:
                    while !operatorStack.isEmpty && operatorStack.last! != .left && operatorStack.last!.precedence > operatorValue.precedence {
                        if !performOperation() {
                            return nil
                        }
                    }
                    operatorStack.append(operatorValue)
                }
                
            }
        }
        while !operatorStack.isEmpty {
            if !performOperation() {
                return nil
            }
            if let last = operatorStack.last, !Operator.calulators.contains(last) {
                operatorStack.removeLast()
            }
        }
        
        return operandStack.reduce(0.0, { $0 + $1 })
    }
    
    enum Operator: String {
        case plus = "+"
        case minus = "-"
        case multiply = "*"
        case rest="%"
        case divide = "/"
        case left = "("
        case right = ")"
        
        static var calulators: Set<Operator> { [.plus, .minus, .multiply, .divide, .rest] }
        
        func apply(left: Double, right: Double) -> Double? {
            switch self {
            case .plus: return left + right
            case .minus: return left - right
            case .multiply: return left * right
            case .divide: return abs(right) < 0.000001 ? nil : left / right
            case .rest: return abs(left) < 1 ? 0 : (abs(right) < 1 ? nil : (left.int%right.int).double)
            default:
                return nil
            }
        }
        
        var precedence: Int {
            switch self {
            case .plus: return 0
            case .minus: return 0
            case .multiply: return 1
            case .divide: return 1
            case .left: return 2
            case .right: return 2
            case .rest: return 3
            }
        }
    }
}
