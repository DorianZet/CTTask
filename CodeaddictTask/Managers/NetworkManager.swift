//
//  NetworkManager.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/"
    let cache = NSCache<NSString, UIImage>()
    static let numberOfObjectsFetched = 70
    
    private init() {}
    
    func getRepos(for query: String, page: Int, completed: @escaping (Result<[Repo], CTError>) -> Void) {
        let endpoint = baseURL + "search/repositories?q=\(query)&per_page=\(NetworkManager.numberOfObjectsFetched)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noSpacesAllowed)) // if url is nil, it's a failure case and we present an error message attached to that case.
            return
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        
        let task = URLSession(configuration: configuration).dataTask(with: url) { (data, response, error) in
            if let _ = error { // that means "if the error exists...". if it doesn't 'error' will be nil, as it's an optional.
                completed(.failure(.unableToComplete))
                return // if we get the error, we don't want the rest of the code to execute, so we return.
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // check if response is nil - and if it isn't, check if its status code is 200 (it means it's OK).
                completed(.failure(.invalidResponse))
                return // if we get the error, we don't want the rest of the code to execute, so we return.
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // we convert the snake case (e.g. 'avatar_url') to camel case ('avatarUrl').
                let reposResponse = try decoder.decode(ReposResponse.self, from: data) // we want an array of Followers, so we try to decode it. We want to create that array of type 'Follower' from 'data', which is above in 'guard let data = data' line above.
                completed(.success(reposResponse.items)) // if all goes well, we get an array of Followers - we described that in the function parameters 'Result<[Follower]' - which goes for the success case.
            } catch { // catching the error.
                completed(.failure(.invalidData))
            }
        }
        
        task.resume() // starts the network call.
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            print("Downloaded cache image")
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                    completed(nil)
                    return
                  }
                  
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completed(image)
            }
        }
        
        task.resume()
    }
    
    func getFirstThreeCommits(from repo: Repo, completed: @escaping (Result<[Commit], CTError>) -> Void) {
        let endpointNoSha = String(repo.commitsUrl.dropLast(6)) + "?per_page=3"
        guard let url = URL(string: String(endpointNoSha)) else {
            completed(.failure(.noSpacesAllowed)) // if url is nil, it's a failure case and we present an error message attached to that case.
            return
        }
        let configuration = URLSessionConfiguration.ephemeral
        
        let task = URLSession(configuration: configuration).dataTask(with: url) { (data, response, error) in
            if let _ = error { // that means "if the error exists...". if it doesn't 'error' will be nil, as it's an optional.
                completed(.failure(.unableToComplete))
                return // if we get the error, we don't want the rest of the code to execute, so we return.
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // check if response is nil - and if it isn't, check if its status code is 200 (it means it's OK).
                completed(.failure(.invalidResponse))
                return // if we get the error, we don't want the rest of the code to execute, so we return.
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // we convert the snake case (e.g. 'avatar_url') to camel case ('avatarUrl').
                let commitsResponse = try decoder.decode([Commit].self, from: data) // we want an array of Followers, so we try to decode it. We want to create that array of type 'Follower' from 'data', which is above in 'guard let data = data' line above.
                completed(.success(commitsResponse)) // if all goes well, we get an array of Followers - we described that in the function parameters 'Result<[Follower]' - which goes for the success case.
            } catch { // catching the error.
                completed(.failure(.invalidData))
            }
        }
        
        task.resume() // starts the network call.
    }
}
