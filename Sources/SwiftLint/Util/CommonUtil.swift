//
//  File.swift
//  
//
//  Created by gzhang on 2022/3/25.
//

import Foundation

open class CommonUtil {
    
    public init() {
        
    }
    
}

extension CommonUtil {
    public func wait(for sec: Int, callback: @escaping () -> Void){
        self.wait(for: Double(sec), callback)
    }
    
    public func wait(for sec: Double, _ callback: @escaping () -> Void){
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
    public enum LogLevel {
        case info,debug,error,warn
    }
    
    public func log(_ content: Any, _ level: LogLevel = .info){
        print("[\(level)] \(content)")
    }
    
    public func i(_ content: Any){
        log(content, .info)
    }
    
    public func d(_ content: Any){
        log(content, .debug)
    }
    
    public func e(_ content: Any){
        log(content, .error)
    }
    
    public func w(_ content: Any){
        log(content, .warn)
    }
}
