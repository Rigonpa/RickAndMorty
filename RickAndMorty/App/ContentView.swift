//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI

private let remoteApi: RemoteApiProtocol = {
    let remoteApi = RickAndMortyApi()
    return remoteApi
}()

private let cache: CacheProtocol = {
    let cache = CoreDataManager()
    return cache
}()

private let interactor: Interactor = {
    let interactor = Interactor(remoteApi: remoteApi, cache: cache)
    return interactor
}()

struct ContentView: View {
    @StateObject var viewModel = ViewModel(interactor: interactor)
    var body: some View {
        ListView()
            .environmentObject(viewModel)
    }
}
