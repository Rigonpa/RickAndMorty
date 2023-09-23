//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        let interactor: CharacterInteractorProtocol = CharacterInteractor()
        let viewModel = ViewModel(interactor: interactor)
        let view = ListView(viewModel: viewModel)
        view
    }
}
