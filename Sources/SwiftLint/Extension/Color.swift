//
//  Color.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

//import SwiftUI
//
//public extension Color {
//    
//    init(hex: Int, alpha: Double = 1) {
//        let components = hex > 0x00FFFFFF ? (
//            R: Double((hex >> 24) & 0xff) / 255,
//            G: Double((hex >> 16) & 0xff) / 255,
//            B: Double((hex >> 08) & 0xff) / 255,
//            A: Double((hex >> 00) & 0xff) / 255
//        ) : (
//            R: Double((hex >> 16) & 0xff) / 255,
//            G: Double((hex >> 08) & 0xff) / 255,
//            B: Double((hex >> 00) & 0xff) / 255,
//            A: alpha
//        )
//        self.init(
//            .sRGB,
//            red: components.R,
//            green: components.G,
//            blue: components.B,
//            opacity: alpha
//        )
//    }
//    
//    static func random() -> Color { Color(red: .randomColorRGB(), green: .randomColorRGB(), blue: .randomColorRGB()) }
//    
//    
//}
