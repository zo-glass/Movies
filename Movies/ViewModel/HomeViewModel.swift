//
//  Movies, HomeViewModel.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import Foundation

// MARK: - HomeViewModel

struct HomeViewModel {
    
    // MARK: - Attributes
    
    private var service = TMDBService()
    var onErrorHandling : (() -> Void)?
    var posters: Observable<[[Poster]]> = Observable([])
    let lists = [TMDBService.List.nowPlaying, TMDBService.List.popular, TMDBService.List.topRated, TMDBService.List.upcoming]
    
    // MARK: - Methods
    
    func fetchAll() {
        for list in lists {
            service.fetchMovie(list: list) { posters in
                if let posters {
                    self.posters.data?.append(posters)
                } else {
                    self.onErrorHandling?()
                }
            }
        }
    }
    
    func update() {
        posters.data = []
        fetchAll()
    }
}

