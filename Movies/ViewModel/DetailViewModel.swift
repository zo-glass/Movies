//
//  Movies, DetailViewModel.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import Foundation

// MARK: - DetailViewModel

struct DetailViewModel {
    
    // MARK: - Attributes
    
    private var service = TMDBService()
    var onErrorHandling : (() -> Void)?
    var movie: Observable<Movie> = Observable(nil)
    
    
    // MARK: - Methods
    
    func fetchMovie(id: Int) {
        let search = User.shared.search(id: id)
        if search.contains {
            movie.data = search.movie
        } else {
            service.fetchMovie(id: id) { movie in
                if let movie {
                    self.movie.data = movie
                } else {
                    self.onErrorHandling?()
                }
            }
        }
    }
    
    func isSaved() -> Bool {
        guard let movie = movie.data else { return false }
        
        return movie.belong(User.shared.saved)
    }
    
    func checkSaveDelete() {
        if isSaved() {
            delete()
        } else {
            create()
        }
    }
    
    func create() {
        guard let movie = movie.data else { return }
        User.shared.create(movie: movie)
    }
    
    func delete() {
        guard let movie = movie.data else { return }
        let id = movie.id
        User.shared.delete(movie: movie)
        self.fetchMovie(id: id)
    }
    
    func deleteOffline() {
        guard let movie = movie.data else { return }
        User.shared.delete(movie: movie)
    }
}

