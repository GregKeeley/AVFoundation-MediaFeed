//
//  URL+VideoPreviewThumbnail.swift
//  AvFoundation-MediaFeed
//
//  Created by Gregory Keeley on 4/13/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import AVFoundation

extension URL {
    public func viedoPreviewThumbnail() -> UIImage? {
        let asset = AVAsset(url: self)
        // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to an image
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        // we want to maintain the aspect ratio of the video
        assetGenerator.appliesPreferredTrackTransform = true
        // create a timestamp of needed location in the video
        // we will use a CMTime to generate the given time stamp
        // CMtime is part of Core Media
        // Retrive the first second of the video
        let timeStamp = CMTime(seconds: 1, preferredTimescale: 60)
        var image: UIImage?
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timeStamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
            // lower level APIs don't know about UIKit, AVKit
            // Change the color of a UIView border
            // ex: someView.layer.borderColor = UIColor.green.cgColor
        } catch {
            print("failed to generate iamge: \(error)")
        }
        return image
    }
}
