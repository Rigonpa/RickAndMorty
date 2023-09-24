//
//  SplashView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.black)
            Image("splash")
                .resizable()
                .scaledToFill()
                .frame(
                    minWidth: 0,
                    maxWidth: .greatestFiniteMagnitude,
                    minHeight: 0,
                    maxHeight: .greatestFiniteMagnitude
                )
        }
    }
}
