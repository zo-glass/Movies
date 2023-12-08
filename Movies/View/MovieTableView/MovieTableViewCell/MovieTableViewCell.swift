//
//  Movies, MovieTableViewCell.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - UITableViewCell

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Attributes
    
    static let identifier = "MovieTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAverangeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.round()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with movie: Movie) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        
        movieImage.image = UIImage(data: movie.image)
        titleLabel.text = movie.title
        voteAverangeLabel.text = String(format: "%.2f", movie.voteAverage)
        dateLabel.text = "Saved on \(dateFormatter.string(from: movie.timestamp))"
    }
    
}
