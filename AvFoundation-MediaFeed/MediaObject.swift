//
//  MediaObject.swift
//  AvFoundation-MediaFeed
//
//  Created by Gregory Keeley on 4/13/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

// MediaObject instance can be a video or image content
struct MediaObject {
    let imageData: Data?
    let videoURL: URL?
    let caption: String?
    let id = UUID().uuidString
    let createDate = Date()
}
