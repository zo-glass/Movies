//
//  Movies, DetailViewController.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - UIViewController

class DetailViewController: UIViewController {
    
    // MARK: - Attributes
    
    var id: Int?
    var isOffline: Bool = false
    var viewModel = DetailViewModel()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var voteAverangeLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
        if let id {
            viewModel.fetchMovie(id: id)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func saveTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Unsave", message: "Are you sure you want to delete this movie?\nThis action cannot be undone.", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.viewModel.deleteOffline()
            self.navigationController?.popViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        if isOffline {
            self.present(alert, animated: true, completion: nil)
        } else {
            viewModel.checkSaveDelete()
            saveButton.setTitle(saveButton.titleLabel?.text == "Save" ? "Unsave" : "Save", for: .normal)
        }
    }
    
    // MARK: - Methods
    
    func configureView() {
        guard let movie = viewModel.movie.data else { return }
        
        movieImage.load(posterPath: movie.posterPath)
        movieImage.round()
        titleLabel.text = movie.title
        taglineLabel.text = movie.tagline
        voteAverangeLabel.text = "\(movie.voteAverage)"
        budgetLabel.text = "\(movie.budget)"
        runtimeLabel.text = "\(movie.runtime)"
        revenueLabel.text = "\(movie.revenue)"
        overviewLabel.text = movie.overview
        saveButton.setTitle(viewModel.isSaved() ? "Unsave" : "Save", for: .normal)
    }
    
    func configureViewModel() {
        viewModel.movie.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.configureView()
            }
        }
        
        viewModel.onErrorHandling = {
            let alert = UIAlertController(title: "Oops!", message: "An error occurred", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

