//
//  ChannelInfo.swift
//  tablo
//
//  Created by Gabe Kangas on 5/22/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import Foundation

struct ChannelInfo {
    var type: ProgramType?
    var name: String?
    var programImage: String?
    
    enum ProgramType {
        case Show, Movie
    }
    
    init(dictionary: [String:AnyObject]) {
        guard let metadata = dictionary["meta"] else {
            return
        }
        
        if let channelName = metadata["callSign"] as? String {
            self.name = channelName
        }
        
        if let movieData = metadata["guideMovie"] as? [String:AnyObject] {
            type = .Movie
            programImage = getImageFromDictionary(movieData)
            if let name = movieData["jsonForClient"]?["title"] as? String {
                self.name = name
            }
        }
        
        if let tvData = metadata["guideSeries"] as? [String:AnyObject] {
            type = .Show
            programImage = getImageFromDictionary(tvData)
            if let name = tvData["jsonForClient"]?["title"] as? String {
                self.name = name
            }
        }
    }
    
    private func getImageFromDictionary(dictionary: [String:AnyObject]) -> String? {
        if let images = dictionary["imageJson"]?["images"] as? Array<[String:AnyObject]> {
            let programImageId = images.last!["imageID"] as! Int
            return  "\(Constants.device)/stream/thumb?id=\(programImageId)&h=1460776179813"
        }

        return nil
    }
}