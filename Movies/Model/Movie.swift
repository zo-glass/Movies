//
//  Movies, Movie.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit
import CoreData

// MARK: - NSManagedObject

@objc(Movie)
class Movie: NSManagedObject {
    
    // MARK: - Attributes
    
    @NSManaged var budget: Int
    @NSManaged var id: Int
    @NSManaged var overview: String
    @NSManaged var posterPath: String
    @NSManaged var revenue: Int
    @NSManaged var runtime: Int
    @NSManaged var tagline: String
    @NSManaged var title: String
    @NSManaged var voteAverage: Double
    @NSManaged var timestamp: Date
    @NSManaged var image: Data
    
    // MARK: - init
    
    convenience init?(json: [String: Any]) {
        let context = UIApplication.shared.delegate as! AppDelegate
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Movie", in: context.persistentContainer.viewContext) else { return nil }
        self.init(entity: entityDescription, insertInto: nil)
        
        guard let budget = json["budget"] as? Int,
              let id = json["id"] as? Int,
              let overview = json["overview"] as? String,
              let poster_path = json["poster_path"] as? String,
              let revenue = json["revenue"] as? Int,
              let runtime = json["runtime"] as? Int,
              let tagline = json["tagline"] as? String,
              let title = json["title"] as? String,
              let voteAverage = json["vote_average"] as? Double
        else {
            return nil
        }
        
        self.budget = budget
        self.id = id
        self.overview = overview
        self.posterPath = poster_path
        self.revenue = revenue
        self.runtime = runtime
        self.tagline = tagline
        self.title = title
        self.voteAverage = voteAverage
    }
    
    // MARK: - Methods
    
    func belong(_ movies: [Movie]) -> Bool {
        for movie in movies {
            if self.id == movie.id {
                return true
            }
        }
        return false
    }
}

// MARK: - Core Data

extension Movie {
    
    class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest(entityName: "Movie")
    }
    
    func create(_ context: NSManagedObjectContext) {
        context.insert(self)
        save(context)
    }

    class func read(_ fetchedResultsController: NSFetchedResultsController<Movie>) -> [Movie] {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        return fetchedResultsController.fetchedObjects ?? []
    }

    func delete(_ context: NSManagedObjectContext) {
        context.delete(self)
        save(context)
    }
    
    private func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

