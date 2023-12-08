//
//  Movies, SavedViewController.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
    

import UIKit
import CoreData

// MARK: - UIViewController

class SavedViewController: UIViewController {
    
    // MARK: - Attributes
    
    var viewModel = SavedViewModel()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var savedTableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.update()
    }
    
    // MARK: - Methods
    
    func configureTableView() {
        savedTableView.dataSource = self
        savedTableView.delegate = self
        savedTableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    func configureViewModel() {
        viewModel.saved.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.savedTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.saved.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        if let movie = viewModel.saved.data?[indexPath.row] {
            cell.configure(with: movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 157.0 : 314.0
        return height
    }
}

// MARK: - UITableViewDelegate

extension SavedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController,
           let id = viewModel.saved.data?[indexPath.row].id {
            detailVC.id = id
            detailVC.isOffline = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

