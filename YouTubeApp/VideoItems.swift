//
//  VideoItems.swift
//  YouTubeApp
//
//  Created by 佐々木　謙 on 2021/03/30.
//

import Foundation

// レスポンス結果の階層を扱う構造体
struct VideoItems {
    
    var title       : String
    var channelTitle: String
    var thumbnailURL: String
    var videoParams : String
    
    init(videTitle: String, videoChannel: String, videoImage: String, videoID: String) {
        
        title        = videTitle
        channelTitle = videoChannel
        thumbnailURL = videoImage
        videoParams  = videoID
    }
}
