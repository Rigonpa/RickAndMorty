//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    
    var body: some Scene {
        WindowGroup {
            let remoteDataManager: RemoteDataManagerProtocol = RemoteDataManager()
            let dataManager = DataManager(remoteDataManager: remoteDataManager)
            let listViewModel = ListViewModel(dataManager: dataManager)
            let listView = ListView(viewModel: listViewModel)
            listView
        }
    }
    
    
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ListView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
}
