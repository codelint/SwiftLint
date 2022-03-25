//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/25.
//

import Foundation

open class CommonUtil {
    
}

extension CommonUtil {
    func wait(for sec: Int, callback: @escaping () -> Void){
        self.wait(for: Double(sec), callback)
    }
    
    func wait(for sec: Double, _ callback: @escaping () -> Void){
        if sec > 0.001 {
            DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
               callback()
            }
        }else{
            callback()
        }
    }
}

/**
 *  logger helper
 */
extension CommonUtil {
    enum LogLevel {
        case info,debug,error,warn
    }
    
    static func log(_ content: Any, _ level: LogLevel = .info){
        print("[\(level)] \(content)")
    }
    
    static func i(_ content: Any){
        log(content, .info)
    }
    
    static func d(_ content: Any){
        log(content, .debug)
    }
    
    static func e(_ content: Any){
        log(content, .error)
    }
    
    static func w(_ content: Any){
        log(content, .warn)
    }
}
