//
//  Movies, SearchViewModel.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
    

import Foundation

// MARK: - SearchViewModel

struct SearchViewModel {
    
    // MARK: - Attributes
    
    private var service = TMDBService()
    var onErrorHandling : (() -> Void)?
    var posters: Observable<[Poster]> = Observable([])
    
    // MARK: - Methods
    
    func fetchSearch(_ text: String) {
        service.fetchSearch(query: text) { posters in
            if let posters {
                self.posters.data = posters
            } else {
                self.onErrorHandling?()
            }
        }
    }
}

