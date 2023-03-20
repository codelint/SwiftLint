//
//  File.swift
//  
//
//  Created by gzhang on 2022/11/8.
//

import Foundation
import CoreData

public extension NSManagedObjectContext {
    
    func exec(_ next: @escaping (NSManagedObjectContext) throws -> Void) -> Bool
    {
        do {
            try next(self)
            return true
        }catch let error{
            print("[ERROR] \(error.localizedDescription)")
        }
        return false
    }
    
    func silentSave() -> Bool
    {
        return self.exec({ try $0.save() })
    }
    
    func merge() -> Void
    {
        _ = self.exec({ try $0.save() })
    }
}

public extension NSPredicate {

    convenience init(from: [String: String?]) {
        
        let predicate_str = from.map { (kv: (key: String, value: String?)) -> String in
            if kv.key.starts(with: "__") {
                return ""
            }
            if let v  = kv.value {
                var op = "=="
                var vv = v
                if v.starts(with: ">") {
                    op = ">"
                } else if v.starts(with: "<") {
                    op = "<"
                } else if v.starts(with: "!="){
                    op = "!="
                }else if v.starts(with: "~=") {
                    op = " IN "
                    if let values = [String].fromJSON(with: vv.substr(start: 2)) {
                        return "\(kv.key) IN {\(values.map({ "'\($0)'" }).joined(separator: ","))}"
                    }else {
                        vv = "\(kv.key) IN {}"
                    }
                } else if v.starts(with: "!~") {
                    if let values = [String].fromJSON(with: vv.substr(start: 2)) {
                        return values.map({ "\(kv.key)!='\($0)'" }).joined(separator: " && ")
                    }else {
                        return ""
                    }
                } else{
                    op = "=="
                    vv = "==\(v)"
                }
    
                return "\(kv.key)\(op)'\(vv.substr(start: op.count))'"
            }else{
                return "\(kv.key)==nil"
            }
            
        }.filter({ str in
            return str.count > 0
        }).joined(separator: " && ")
        
        self.init(format: predicate_str)
    }
}
