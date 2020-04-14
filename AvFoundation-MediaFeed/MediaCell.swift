//
//  MediaCell.swift
//  AvFoundation-MediaFeed
//
//  Created by Gregory Keeley on 4/13/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    public func configureCell(for mediaObject: MediaObject) {
        if let imageData = mediaObject.imageData {
            mediaImageView.image = UIImage(data: imageData)
        }
        // Create a thumbnail preview of a video
        if let videoURL = mediaObject.videoURL {
        let image = videoURL.viedoPreviewThumbnail() ??
            UIImage(systemName: "heart")
            mediaImageView.image = image
        }
    }
}
