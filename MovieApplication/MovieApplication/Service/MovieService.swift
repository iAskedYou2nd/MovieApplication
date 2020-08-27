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
    
    func fetch<T>(url: URL?, completion: @escaping (Result<T, NetworkError>) -> ()) where T: Codable {
        
        guard let url = url else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.error(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure))
            }
            
        }.resume()
    }
    
    func fetch(url: URL?, completion: @escaping ImageHandler) {
        
        guard let url = url else {
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
