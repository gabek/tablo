//
//  Channel.swift
//  tablo
//
//  Created by Gabe Kangas on 5/21/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import Foundation


struct Channel {
    var id: Int
    var title: String?
    
    init(id: Int) {
        self.id = id
    }
    
    var image: String {
        var name = String(id)
        if let title = title {
            name = title.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        }
       return "http://hostedfiles.netcommtx.com/Tablo/plex/makeposter.php?text=" + name
    }
}