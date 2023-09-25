//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        if viewModel.appIsNotReady() {
            SplashView()
                .onAppear {
                    viewModel.getInitialData()
                }
        } else {
            NavigationView {
                
                VStack {
                    Spacer(minLength: 32)
                    
                    Text("Rick And Morty Characters")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                    
                    SegmentedControlView(
                        currentStatus: viewModel.currentStatus,
                        statusValues: viewModel.statusValues
                    ) { newStatus in
                        viewModel.loadCharactersWith(status: newStatus)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 64)
                    
                    if viewModel.characters.count != 0 {
                        showList(characters: viewModel.characters)
                    } else {
                        loading()
                    }
                }
            }
            .onAppear {
                viewModel.loadCharactersWith(status: .alive)
            }
        }
    }
    
    func showList(characters: [Character]) -> some View {
        List {
            ForEach(characters) { character in
                CharacterRowView(character: character)
                    .task {
                        if viewModel.fetchingNextPage == false {
                            viewModel.hasReached(lastVisible: character.id)
                        }
                    }
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.fetchingNextPage {
                loading()
            }
        }
    }
    
    func loading() -> some View {
        ProgressView()
    }
}
