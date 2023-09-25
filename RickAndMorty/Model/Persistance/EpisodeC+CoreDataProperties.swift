//
//  EpisodeC+CoreDataProperties.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//
//

import Foundation
import CoreData


extension EpisodeC {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeC> {
        return NSFetchRequest<EpisodeC>(entityName: "EpisodeC")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var episode: String
    @NSManaged public var airDate: String

}

extension EpisodeC : Identifiable {

}
