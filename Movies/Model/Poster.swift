//
//  Movies, Poster.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import Foundation

// MARK: - Poster

struct Poster {
    
    // MARK: - Attributes
    
    let id: Int
    let poster_path: String
    let title: String
    let vote_average: Double
    
    // MARK: - init
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let poster_path = json["poster_path"] as? String,
              let title = json["title"] as? String,
              let vote_average = json["vote_average"] as? Double
        else {
            return nil
        }
        
        self.id = id
        self.poster_path = poster_path
        self.title = title
        self.vote_average = vote_average
    }
}

