//
//  Movies, SavedViewModel.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
    

import Foundation

// MARK: - SavedViewModel

struct SavedViewModel {
    
    // MARK: - Attributes
    
    var saved: Observable<[Movie]> = Observable(nil)
    
    // MARK: - Methods
    
    func update() {
        saved.data = User.shared.saved
    }
}

