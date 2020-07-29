//
//  MovieService.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

class MovieService {
    
    var session: URLSession
    var decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
}

extension MovieService: ServiceType {
    
    func fetchNowPlaying(completion: @escaping PageResultHandler) {
        
        guard let url = URL(string: MovieServiceConstants.baseURL + MovieServiceConstants.nowPlaying + MovieServiceConstants.apiKey) else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
                        
            guard error == nil else {
                completion(.failure(.error(error?.localizedDescription ?? "Nothing")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let result = try self.decoder.decode(PageResult.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure))
            }
            
        }.resume()
    }
    
    func fetchPopular(with page: Int, completion: @escaping PageResultHandler) {
        
        guard let url = URL(string: MovieServiceConstants.baseURL + MovieServiceConstants.popular + MovieServiceConstants.apiKey + MovieServiceConstants.pageQuery + "\(1)") else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(error?.localizedDescription ?? "Nothing")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let result = try self.decoder.decode(PageResult.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure))
            }
            
        }.resume()
        
    }
    
    func fetchMovie(id: Int, completion: @escaping MovieDetailHandler) {
        
        guard let url = URL(string: MovieServiceConstants.baseURL + "\(id)" + MovieServiceConstants.apiKey) else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(error?.localizedDescription ?? "Nothing")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let result = try self.decoder.decode(Movie.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure))
            }
            
        }.resume()
        
    }
    
    func fetchImage(urlString: String, completion: @escaping ImageHandler) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(error?.localizedDescription ?? "Nothing")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            completion(.success(data))
            
        }.resume()
        
    }
    
}
