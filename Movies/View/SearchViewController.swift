//
//  Movies, SearchViewController.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import UIKit

// MARK: - UIViewController

class SearchViewController: UIViewController {
    
    // MARK: - Attributes
    
    var viewModel = SearchViewModel()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMoviesTableView()
        configureViewModel()
    }
    
    // MARK: - Methods
    
    func configureMoviesTableView() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
    }
    
    func configureViewModel() {
        viewModel.posters.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
        
        viewModel.onErrorHandling = {
            let alert = UIAlertController(title: "Oops!", message: "An error occurred", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posters.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        // content.attributedText = NSAttributedString(string: viewModel.posters.data?[indexPath.row].title ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Velour", size: 17)!])
        content.text = viewModel.posters.data?[indexPath.row].title ?? ""
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController, let id = viewModel.posters.data?[indexPath.row].id {
            detailVC.id = id
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchSearch(searchText)
    }
}

