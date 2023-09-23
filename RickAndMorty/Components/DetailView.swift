//
//  DetailView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 23/9/23.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
            Text("Página detalle de personaje")
        }.onAppear {
            viewModel.send(event: .viewAppeared)
        }
    }
}
