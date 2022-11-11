//
//  Array.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import Foundation

public extension Dictionary{
    
    func add(key: Key, value: Value) -> Dictionary<Key, Value> {
        
        var newOne = self
        newOne[key] = value
        
        return newOne
        
    }
    
    func only(keys: [Key]) -> Dictionary<Key, Value>{
        return self.filter { (key, value) in keys.contains(where: { $0 == key }) }
    }
    
    func except(keys: [Key]) -> Dictionary<Key, Value> {
        return self.filter { (key, value) in !keys.contains(where: { $0 == key }) }
    }
    
    func asyncEach(
        _ keys: [Key],
        from: Int = 0,
        next: @escaping ((Value, Key, @escaping () -> Void) -> Void),
        first: ((Value, Key, @escaping () -> Void) -> Void)? = nil,
        last: ( (Value, Key) -> Void)? = nil
    ) {
        if from < keys.count {
            let f = first == nil ? { _, _ , next in
                next()
            } : first!
            
            let key = keys[from]
            let element = self[key]!
            f(element, key) {
                let nextIdx = from + 1
                next(element, keys[from]) {
                    if nextIdx < keys.count {
                        self.asyncEach(keys, from: nextIdx, next: next, last: last)
                    }else {
                        last?(element, key)
                    }
                }
            }
        }
    }
    
    func loop( _ next: @escaping (Value, Key, (() -> Void)?) -> Void) {
        var keys: [Key] = []
        self.keys.forEach { k in
            keys.append(k)
        }
        
        self.asyncEach(keys, next: next)
    }
    
}

public extension Dictionary where Key:Comparable{
    func loop( _ next: @escaping (Value, Key, (() -> Void)?) -> Void) {

        let keys = self.keys.sorted()
        
        self.asyncEach(keys, next: next)
    }
}

//public extension Dictionary where Key: StringProtocol {
//    func keyStringify() -> [String: Value] {
//        var dict: [String: Value] = [:]
//
//        self.forEach { (key, value) in
//            dict[key.description] = value
//        }
//
//        return dict
//    }
//}

//public extension Optional {
//    func let(){
//        
//    }
//}

public extension Set {
    var array: [Element] {
        var elements: [Element] = []
        self.forEach { e in
            elements.append(e)
        }
        return elements
    }
}

public extension Array where Element: Equatable {
    
    func contains(elements: [Element]) -> Bool{
        let filters = elements.filter { e in
            return self.contains(where: { $0 == e })
        }
        
        return filters.count == elements.count
    }
    
    func except(e: Element) -> Self {
        return except(elements: [e])
    }
    
    func only(e: Element) -> Self {
        return self.only(elements: [e])
    }
    
    func except(elements: [Element]) -> Self
    {
        return self.filter({ !elements.contains($0) })
    }
    
    func only(elements: [Element]) -> Self
    {
        return self.filter({ elements.contains($0) })
    }
}

public extension Array {
    
    func groupBy<Key: Hashable>(key: (Element) -> Key?) -> [Key: [Element]]{
        var results = [Key: [Element]]()
        for element in self {
            // print("beep[\(beep.name)] at \(Date(timeIntervalSince1970: Double(beep.end_time)).datetimeString)")
            if let label = key(element) {
                if !results.keys.contains(label) {
                    results[label] = [Element]()
                }
                
                results[label]?.append(element)
            }
        }
        
        return results
    }
    
    func uniq(key: (Element) -> String?) -> [Element]{
        
        let grouped = self.groupBy(key: key)
        
        return grouped.enumerated().map { (e) -> Element in
            
            return e.element.value[0]
        }
        
    }
    
    func loop(_ next: @escaping ((Element, @escaping () -> Void) -> Void)) {
        self.asyncEach(self, next: { element, idx, pass in
            next(element, pass)
        })
    }
    
    func asyncEach(
        _ arr: [Element],
        from: Int = 0,
        next: @escaping ((Element, Int, @escaping () -> Void) -> Void),
        first: ((Element, @escaping () -> Void) -> Void)? = nil,
        last: ( (Element) -> Void)? = nil
    ) {
        if from < arr.count {
            let f = first == nil ? { _, next in
                next()
            } : first!
            
            f(arr[from]) { 
                let nextIdx = from + 1
                next(arr[from], from) {
                    if nextIdx < arr.count {
                        // print("\(nextIdx) < \(arr.count)")
                        self.asyncEach(self, from: nextIdx, next: next, last: last)
                    }else {
                        last?(arr[from])
                    }
                }
                
            }
        }
    }
    
}

public extension Array where Element: Numeric {
 
    func sum() -> Element {
        return self.reduce(.zero) { memo, num in
            return memo + num
        }
    }
    
}

public extension Array where Element: Comparable {
    
    func max() -> Element? {
        return self.reduce(nil) { memo, num in
            if let memo = memo {
                return memo < num ? num : memo
            }else {
                return num
            }
        }
    }
    
    func min() -> Element? {
        return self.reduce(nil) { memo, num in
            if let memo = memo {
                return memo < num ? memo : num
            }else {
                return num
            }
        }
    }
    
}
