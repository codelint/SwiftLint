//
//  Color.swift
//  going
//
//  Created by gzhang on 2021/3/26.
//

import SwiftUI

extension Color {
    
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
    
    static func random() -> Color {
        return Color(red: .randomColorRGB(), green: .randomColorRGB(), blue: .randomColorRGB())
    }
    
    static let lightgray = Color(hex: 0xf1f1f1)
    static let lightorange = Color(hex: 0xfed8b1)
    static let lightred = Color(hex: 0xff6961)
    static let lightblue = Color(hex: 0x6495ec)
    static let thinblue = Color(hex: 0xd3def5)
    
    
}
