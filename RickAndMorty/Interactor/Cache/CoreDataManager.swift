//
//  CoreDataManager.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//

import UIKit
import CoreData

enum PersistenceError: Error {
    case savingError
    case loadingError
}

class CoreDataManager: CacheProtocol {
    lazy var context: NSManagedObjectContext = {
        let persistanceController = PersistenceController.shared
        return persistanceController.container.viewContext
    }()
}

// MARK: - Characters

// ...

// MARK: - Episodes

extension CoreDataManager {
    
    func persistEpisodes(episodes: [Episode]) throws -> Bool {
        if let entity = NSEntityDescription.entity(forEntityName: String(describing: EpisodeC.self), in: context) {
            episodes.forEach { episode in
                let episodeC = EpisodeC(entity: entity, insertInto: context)
                episodeC.id = episode.id
                episodeC.name = episode.name
                episodeC.episode = episode.episode
                episodeC.airDate = episode.airDate
                
            }
            try context.save()
            
            return true
        }
        throw PersistenceError.savingError
    }
    
    func getEpisodes() throws -> [Episode] {
        
        let request = NSFetchRequest<EpisodeC>(entityName: String(describing: EpisodeC.self))
        do {
            var list = try context.fetch(request)
            list.sort(by: { $0.id < $1.id} )
            
            var episodes = list.map {
                Episode(id: $0.id, name: $0.name, episode: $0.episode, airDate: $0.airDate)
            }
            return episodes
        } catch {
            throw PersistenceError.loadingError
        }
    }
}
