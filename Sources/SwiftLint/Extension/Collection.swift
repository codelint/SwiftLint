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

public extension Array where Element: Equatable {
    
    func contains(elements: [Element]) -> Bool{
        let filters = elements.filter { e in
            return self.contains(where: { $0 == e })
        }
        
        return filters.count == elements.count
    }
    
    func except(e: Element) -> Self {
        return self.filter({ $0 != e })
    }
    
    func only(e: Element) -> Self {
        return self.filter({ $0 == e })
    }
    
}

public extension Array {
    
    func groupBy(key: (Element) -> String?) -> [String: [Element]]{
        var results = [String: [Element]]()
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
                        if let l = last {
                            l(arr[from])
                        }
                    }
                }
                
            }
        }
    }
    
}
