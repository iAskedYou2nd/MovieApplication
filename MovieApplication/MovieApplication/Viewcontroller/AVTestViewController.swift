//
//  AVTestViewController.swift
//  MovieApplication
//
//  Created by iAskedYou2nd on 8/28/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit
import AVKit
import WebKit

class AVTestViewController: UIViewController {

    var viewModel: ViewModelType?
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        self.tableView = table
        table.boundToSuperView(inset: 8.0)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "123")
        table.delegate = self
        table.dataSource = self
        
        
    }
    
    
    func displayVideo(url: URL) {
        let player = AVPlayer(url: url)
        let avController = AVPlayerViewController()
        avController.player = player
        
        self.present(avController, animated: true) {
            avController.player?.play()
        }
    }

    
}

extension AVTestViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.videos(index: 2).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "123", for: indexPath)
        
        cell.textLabel?.text = self.viewModel?.videos(index: 2)[indexPath.row].name
        return cell
    }
    
}

extension AVTestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoKey = self.viewModel?.videos(index: 2)[indexPath.row].key ?? ""
        if let url = MovieServiceRequest.youtubeVideo(videoKey).url {
//            self.displayVideo(url: url)
            
            var mywkwebview: WKWebView?
            let mywkwebviewConfig = WKWebViewConfiguration()

            mywkwebviewConfig.allowsInlineMediaPlayback = true
            mywkwebview = WKWebView(frame: self.view.frame, configuration: mywkwebviewConfig)

//            let myURL = URL(string: "https://www.youtube.com/embed/1roy4o4tqQM?playsinline=1?autoplay=1")
            var youtubeRequest = URLRequest(url: url)

            mywkwebview?.load(youtubeRequest)
            
            self.view.addSubview(mywkwebview!)
        }
        
        
        
    }
    
    
}
