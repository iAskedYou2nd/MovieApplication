//
//  NetworkError.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badData
    case decodeFailure
    case noNetwork
    case error(String)
}

extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("Bad URL, could not convert string to URL", comment: "Bad URL")
        case .badData:
            return NSLocalizedString("Bad data, the data was corrupted or incorrect", comment: "Bad data")
        case .decodeFailure:
            return NSLocalizedString("Decoding failure, the data could not be decoded to the model", comment: "Decode Failure")
        case .noNetwork:
            return NSLocalizedString("No available network", comment: "No network")
        case .error(let localizedString):
            return NSLocalizedString(localizedString, comment: "Normal Error")
        }
    }
    
}
