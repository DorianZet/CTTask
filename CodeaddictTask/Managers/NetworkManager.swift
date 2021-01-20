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
    static let numberOfObjectsFetched = 50
    
    private init() {}
    
    func getRepos(withSession session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.ephemeral), for query: String, page: Int, completed: @escaping (Result<[Repo], CTError>) -> Void) {
        let endpoint = baseURL + "search/repositories?q=\(query)&per_page=\(NetworkManager.numberOfObjectsFetched)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.noSpacesAllowed))
            return
        }
                
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let reposResponse = try decoder.decode(ReposResponse.self, from: data)
                completed(.success(reposResponse.items))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getRepo(withSession session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.ephemeral), fromUrlString urlString: String, completed: @escaping (Result<Repo, CTError>) -> Void) {
        let endpoint = urlString
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.wrongRepoUrl))
            return
        }
                
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let repo = try decoder.decode(Repo.self, from: data)
                completed(.success(repo))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImageTask(from urlString: String, completed: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return nil
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
        } as URLSessionDataTask
        
        return task
    }
    
    func getFirstThreeCommits(withSession session: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.ephemeral), from repo: Repo, completed: @escaping (Result<[Commit], CTError>) -> Void) {
        let endpointNoSha = String(repo.commitsUrl.dropLast(6)) + "?per_page=3"
        guard let url = URL(string: String(endpointNoSha)) else {
            completed(.failure(.wrongCommitsUrl))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard response.statusCode != 409 else {
                completed(.failure(.commitsEmpty))
                return
            }
            
            guard response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let commitsResponse = try decoder.decode([Commit].self, from: data)
                completed(.success(commitsResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
