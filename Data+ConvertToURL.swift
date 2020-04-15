//
//  Data+ConvertToURL.swift
//  AvFoundation-MediaFeed
//
//  Created by Gregory Keeley on 4/15/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

extension Data {
    // let url = mediaObject.videoData.convertToURL()
    // let url = mediaObject.self.convertToURL()
    public func convertToURL() -> URL? {
        // create a temporary URL
        // NSTemporaryDirectory() - Stores temporary files, those files get deleted as needed by the operating system
        // Documents directory is for permanent storage
        // Caches directory is temp storage
        
        // in Core Data the video is saved as Data
        // When playing back the video we need to have a URL pointing to the video location on disk
        // AVPlayer needs a URL pointing to a location on disk
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        do {
            try self.write(to: tempURL, options: [.atomic])
            return tempURL
        } catch {
            print("failed to write video data to temporary file with error: \(error)")
        }
        return nil
    }
}
