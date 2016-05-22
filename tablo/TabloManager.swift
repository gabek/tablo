//
//  TabloManager.swift
//  tablo
//
//  Created by Gabe Kangas on 5/21/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import Foundation
import AFNetworking

struct TabloManager {
    let device = "http://10.0.1.74"
    let manager = AFHTTPSessionManager()

    init() {
        manager.requestSerializer = AFJSONRequestSerializer()
    }
    
    func getStations(completion: (channels: [Channel]) -> Void) {
        let url = device + ":18080/plex/ch_ids"
        
        manager.GET(url, parameters: nil, progress: nil, success: { (task, result) in
            // Success            
            if let ids = result?["ids"] as? [Int] {
                let channels = self.channelsFromIds(ids)
                let batchGroup = dispatch_group_create()
                
                var namedChannels = [Channel]()
                for channel in channels {
                    dispatch_group_enter(batchGroup)
                    self.getStationNameForId(channel.id, completion: { (name) in
                        var namedChannel = Channel(id: channel.id)
                        namedChannel.title = name
                        namedChannels.append(namedChannel)
                        dispatch_group_leave(batchGroup)
                    })
                }
                
                dispatch_group_notify(batchGroup, dispatch_get_main_queue(), {
                    completion(channels: namedChannels)
                })

            }
            
            
            }) { (task, error) in
                // Error
                print(error)
        }
    }
    
    func getStreamForStationId(id: Int, completion: (stream: String) -> Void) {
        let url = device + ":8886/"
        let params = ["channelid": id]
        let command = ["jsonrpc": 2.0, "id": 1, "method": "/player/watchLive", "params": params]
        
        manager.POST(url, parameters: command, progress: nil, success: { (task, result) in
            if let result = result, stream = result["result"]??["relativePlaylistURL"] as? String {
                let fullStream = self.device + stream
                completion(stream: fullStream)
            }
            
            }) { (task, error) in
                print(error)
                completion(stream: "http://c5676e956e00a92c0029-149333bb05f970c39fc9612992dd8b45.r89.cf1.rackcdn.com/No_lock.mp4")
        }
    }
    
    private func getStationNameForId(id: Int, completion: (name: String) -> Void) {
        let url = device + ":18080/plex/ch_info?id=" + String(id)
        
        manager.GET(url, parameters: nil, progress: nil, success: { (task, result) in
            guard let metadata = result?["meta"] else {
                return completion(name: "")
            }
            
            if let callsign = metadata?["callSign"] as? String, affiliate = metadata?["affiliateCallSign"] as? String {
                let name = "\(callsign) - \(affiliate)"
                completion(name: name)
            } else {
                completion(name: String(id))
            }
        
            }) { (task, error) in
                print(error)
        }
    }
    
    func nowPlayingOnStation(id: Int, completion: (info: ChannelInfo) -> Void) {
        let url = device + ":18080/plex/ch_epg?id=" + String(id)
        
        manager.GET(url, parameters: nil, progress: nil, success: { (task, result) in
            if let result = result as? [String: AnyObject] {
                let info = ChannelInfo(dictionary: result)
                completion(info: info)
            }
            }) { (task, error) in
                print(error)
        }
    }

    private func channelsFromIds(ids: [Int]) -> [Channel] {
        let channels = ids.map({ return Channel(id: $0) })
        return channels
    }
}