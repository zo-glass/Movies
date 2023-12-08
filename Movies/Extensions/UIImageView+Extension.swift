//
//  Movies, UIImageView+Extension.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

extension UIImageView {
    func load(posterPath: String) {
        TMDBService().fetchImage(posterPath: posterPath) { data in
            if let data, let image = UIImage(data: data) {
                self.image = image
            }
        }
    }
    
    func round() {
        self.layer.cornerRadius = frame.width / 25
        self.clipsToBounds = true
    }
}

