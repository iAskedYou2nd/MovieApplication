//
//  UIViewController+Utils.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/14/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertController(for error: NetworkError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
