//
//  Movies, TMDBService.swift
//  macOS 13.4, Swift 5.0
//
//  Created by zo_glass
//
        

import Foundation
import Alamofire

// MARK: - Enums

extension TMDBService {
    
    enum List: String {
        case nowPlaying = "now_playing"
        case popular = "popular"
        case topRated = "top_rated"
        case upcoming = "upcoming"
    }
}

// MARK: - TMDBService

class TMDBService {
    
    // MARK: - Attributes
    
    private let endpoint = "https://api.themoviedb.org/3/"
    private let imageEndpoint = "https://image.tmdb.org/t/p/w500/"
    private let api_key = "api_key=YOUR_API_KEY_HERE"    // https://developer.themoviedb.org/docs/getting-started
    
    // MARK: - Methods
    
    func fetchMovie(list: List, completion: @escaping(_ posters: [Poster]?) -> Void) {
        AF.request("\(endpoint)movie/\(list.rawValue)?\(api_key)").response { response in
            switch response.result {
            case .success:
                completion(self.decoding(response.data))
            case .failure:
                completion(nil)
            }
        }
    }
    
    func fetchSearch(query: String, completion: @escaping(_ posters: [Poster]?) -> Void) {
        if let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            AF.request("\(endpoint)search/movie?query=\(query)&\(api_key)").response { response in
                switch response.result {
                case .success:
                    completion(self.decoding(response.data))
                case .failure:
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func fetchMovie(id: Int, completion: @escaping(_ poster: Movie?) -> Void) {
        AF.request("\(endpoint)movie/\(id)?\(api_key)").response { response in
            switch response.result {
            case .success:
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let movie = Movie(json: json) {
                    completion(movie)
                }
            case .failure:
                completion(nil)
            }
        }
    }
    
    func fetchImage(posterPath: String, completion: @escaping(_ data: Data?) -> Void) {
        AF.request("\(imageEndpoint)\(posterPath)").response { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    completion(data)
                } else {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func decoding(_ data: Data?) -> [Poster]? {
        guard let data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]] else { return nil }
        var posters: [Poster] = []
        
        // if results.isEmpty { return nil }
        
        for result in results {
            if let poster = Poster(json: result) {
                posters.append(poster)
            }
        }
        
        return posters
    }
}

