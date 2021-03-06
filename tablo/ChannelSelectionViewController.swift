//
//  ChannelSelectionViewController.swift
//  scifitv
//
//  Created by Gabe Kangas on 2/22/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import MediaPlayer
import TVServices
import AVKit

class ChannelSelectionViewController: UIViewController {
    var collectionView: UICollectionView!
    var channels: [Channel]? {
        didSet {
            getNowPlayingInfo()
        }
    }
    
    var nowPlayingInfo = [Int:ChannelInfo]()
    
    let tabloManager = TabloManager()
    
    override func viewDidLoad() {
        navigationController?.navigationBarHidden = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(450, 450)
        layout.minimumInteritemSpacing = 50
        layout.minimumLineSpacing = 70
        layout.headerReferenceSize = CGSizeMake(200, 150)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerClass(ChannelCell.self, forCellWithReuseIdentifier: "ChannelCell")
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.contentInset = UIEdgeInsetsMake(70, 100, 70, 100)
        
        updateViewConstraints()
        tabloManager.getStations { (channels) in
            self.channels = channels
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if channels != nil && nowPlayingInfo.count > 0 {
            getNowPlayingInfo()
        }
    }
    
    private func getNowPlayingInfo() {
        guard let channels = channels else {
            return
        }
        
        for channel in channels {
            tabloManager.nowPlayingOnStation(channel.id, completion: { (info) in
                self.nowPlayingInfo[channel.id] = info
                
                if self.nowPlayingInfo.count == channels.count {
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    private var didSetupConstraints = false
    override func updateViewConstraints() {
        if !didSetupConstraints {
            collectionView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
            collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
            collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
            collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

extension ChannelSelectionViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let channels = channels {
            let channel = channels[indexPath.item]
            let vc = VideoViewController()
            navigationController?.pushViewController(vc, animated: true)
            
            let id = channel.id
            tabloManager.getStreamForStationId(id, completion: { (stream) in
                vc.play(NSURL(string: stream)!)
            })
        }
    }
}

extension ChannelSelectionViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let channels = channels {
            return channels.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChannelCell", forIndexPath: indexPath) as! ChannelCell
        
        if let channels = channels {
            let channel = channels[indexPath.item]
            cell.imageView.setImageWithURL(NSURL(string: channel.image)!)

            if let info = nowPlayingInfo[channel.id], url = info.programImage {
                cell.imageView.setImageWithURL(NSURL(string: url)!)
                cell.titleLabel.text = info.name
            } else if let name = channel.title {
                cell.titleLabel.text = name
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath)
        let label = UILabel()
        label.text = "Channels"
        label.textColor = UIColor(white: 0.7, alpha: 0.8)
        label.frame = CGRectMake(0, 0, 500, 150)
        label.font = UIFont.systemFontOfSize(100)
        view.addSubview(label)
        return view
    }
}