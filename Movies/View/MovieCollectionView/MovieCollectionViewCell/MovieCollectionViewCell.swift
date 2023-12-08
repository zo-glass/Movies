//
//  Movies, MovieCollectionViewCell.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
    

import UIKit

// MARK: - UICollectionViewCell

class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Attributes
    
    static let identifier = "MovieCollectionViewCell"
    
    // MARK: - IBOutlets

    @IBOutlet weak var movieImage: UIImageView!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.round()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }
    
    public func configure(with poster: Poster) {
        movieImage.load(posterPath: poster.poster_path)
    }
}
