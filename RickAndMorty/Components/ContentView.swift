//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        ListView()
            .environmentObject(viewModel)
    }
}
