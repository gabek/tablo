//
//  VideoViewController.swift
//  tablo
//
//  Created by Gabe Kangas on 5/22/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import Foundation
import MediaPlayer
import TVServices
import AVKit

class VideoViewController: AVPlayerViewController {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    convenience init(url: NSURL) {
        self.init()
        play(url)
    }
    
    deinit {
        player?.removeObserver(self, forKeyPath: "status")
    }
    
    func play(url: NSURL) {
        player = AVPlayer(URL: url)
        player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
        player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(spinner)
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        spinner.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        spinner.hidesWhenStopped = true
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            statusChanged()
        }
    }
    
    @objc private func statusChanged() {
        let status = player?.status
        print(status?.rawValue)
        
        if status == .ReadyToPlay {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }        
    }
}
