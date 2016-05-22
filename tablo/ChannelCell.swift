//
//  ChannelCell.swift
//  scifitv
//
//  Created by Gabe Kangas on 2/22/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import Foundation
import UIKit

class ChannelCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        imageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        imageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
        imageView.adjustsImageWhenAncestorFocused = true
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraintEqualToAnchor(imageView.topAnchor).active = true
        titleLabel.bottomAnchor.constraintEqualToAnchor(imageView.bottomAnchor).active = true
        titleLabel.leftAnchor.constraintEqualToAnchor(imageView.leftAnchor).active = true
        titleLabel.rightAnchor.constraintEqualToAnchor(imageView.rightAnchor).active = true
        titleLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(50)
        titleLabel.numberOfLines = 0
        
        backgroundColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({ [unowned self] in
            if self.focused {
                self.titleLabel.alpha = 0.0
            } else {
                self.titleLabel.alpha = 1.0
            }
            
            }, completion: nil)
    }
    
}