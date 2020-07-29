//
//  MovieListViewController+Delegate.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }
        self.navigateToDetail(with: indexPath.row, viewModel: self.popularViewModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = .darkGray
        header.textLabel?.textColor = .systemYellow
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}



extension MovieListViewController: CellSelectedDelegate {
    
    func navigateToDetail(with index: Int, viewModel: ViewModelType) {
        DispatchQueue.main.async {
            let detailVC = MovieDetailViewController(viewModel: viewModel, index: index, delegate: self)
            let navVC = UINavigationController()
            navVC.viewControllers = [detailVC]
            navVC.navigationBar.barTintColor = .clear
            navVC.modalPresentationStyle = .overFullScreen
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    func presentAlert(error: NetworkError) {
        DispatchQueue.main.async {
            self.presentAlertController(for: error)
        }
    }
    
}

extension MovieListViewController: DismissDetailDelegate {
    
    func dismissDetail() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
