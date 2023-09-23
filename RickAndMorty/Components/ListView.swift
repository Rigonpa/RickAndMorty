//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            if case let .loaded(loadedState) = viewModel.state  {
                showList(characters: loadedState.characters)
            } else {
                loading()
            }
        }
        .onAppear {
            viewModel.loadCharacters()
        }
        .navigationDestination(for: Router.self) { router in
            switch router {
            case .detail:
//                DetailView(viewModel: <#DetailViewModel#>)
            }
        }
    }
    
    func loading() -> some View {
        ProgressView()
    }
    
    func showList(characters: [Character]) -> some View {
        List {
            ForEach(characters) { character in
                HStack {
                    RemoteImage(urlString: character.image)
                    NavigationLink(value: Router.detail) {
                        Text(character.name)
                            .bold()
                    }
                    
                }
            }
        }
        .navigationTitle("Rick And Morty")
        .listRowSeparator(.hidden)
    }
}
