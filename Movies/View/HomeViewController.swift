//
//  Movies, HomeViewController.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - UIViewController

class HomeViewController: UIViewController {
    
    // MARK: - Attributes
    
    var viewModel = HomeViewModel()

    
    // MARK: - IBOutlets

    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMovieCollectionView()
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.update()
    }
    
    // MARK: - Methods
    
    func configureMovieCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = (movieCollectionView.frame.width - 32 ) / 3
        let height = width * 1.5
        layout.itemSize = CGSize(width: width, height: height)
        movieCollectionView.collectionViewLayout = layout
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        movieCollectionView.register(MovieHeaderCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderCollectionReusableView.identifier)
    }
    
    func configureViewModel() {
        viewModel.posters.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.movieCollectionView.reloadData()
            }
        }
        
        viewModel.onErrorHandling = {
            let alert = UIAlertController(title: "Oops!", message: "An error occurred", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posters = viewModel.posters.data, !posters.isEmpty {
            return posters[section].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        if let poster = viewModel.posters.data?[indexPath.section][indexPath.row] {
            cell.configure(with: poster)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.posters.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderCollectionReusableView.identifier, for: indexPath) as! MovieHeaderCollectionReusableView
        var title: String
        
        switch viewModel.lists[indexPath.section] {
        case .nowPlaying:
            title = "Now Playing"
        case .popular:
            title = "Popular"
        case .topRated:
            title = "Top Rated"
        case .upcoming:
            title = "Upcoming"
        }
        
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 75.0 : 100.0
        return CGSize(width: 320, height: height)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController,
           let id = viewModel.posters.data?[indexPath.section][indexPath.row].id {
            detailVC.id = id
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (movieCollectionView.frame.width - 32 ) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}

