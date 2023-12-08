//
//  Movies, MovieHeaderCollectionReusableView.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
    

import UIKit

// MARK: - UICollectionReusableView

class MovieHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Attributes
    
    static let identifier = "MovieHeaderCollectionReusableView"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var headerLabel: UILabel!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieHeaderCollectionReusableView", bundle: nil)
    }
    
    public func configure(with title: String) {
        headerLabel.text = title
    }
    
}
