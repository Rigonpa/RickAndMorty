//
//  Color+Ext.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation
import SwiftUI

public extension Color {
    
    static func random(randomOpacity: Bool = false) -> Color {
        [.red, .orange, .green, .yellow, .blue, .purple, .pink, .brown, .cyan, .indigo, .mint].randomElement() ?? .orange
    }
}
