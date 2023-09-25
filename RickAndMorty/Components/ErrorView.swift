//
//  ErrorView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        print(error)
        return Text("❌").font(.system(size: 60))
    }
}
