//
//  Movies, User.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit
import CoreData

// MARK: - NSObject

class User: NSObject {
    
    // MARK: - Attributes
    
    var saved: [Movie] = []
    
    static var shared: User = {
        return User()
    }()
    
    private var service = TMDBService()
    
    private var context: NSManagedObjectContext = {
        let context = UIApplication.shared.delegate as! AppDelegate
        return context.persistentContainer.viewContext
    }()
    
    private var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = UIApplication.shared.delegate as! AppDelegate
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    // MARK: - init
    
    override init() {
        super.init()
        fetchedResultsController.delegate = self
        read()
    }
    
    // MARK: - Methods
    
    func create(movie: Movie) {
        service.fetchImage(posterPath: movie.posterPath) { data in
            if let data {
                movie.image = data
                movie.timestamp = Date()
                movie.create(self.context)
                self.read()
            }
        }
    }
    
    func read() {
        saved = Movie.read(fetchedResultsController)
    }
    
    func delete(movie: Movie) {
        movie.delete(context)
    }
    
    func search(id: Int) -> (contains: Bool, movie: Movie?){
        for movie in saved {
            if id == movie.id {
                return (true, movie)
            }
        }
        return (false, nil)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension User: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        read()
    }
}

