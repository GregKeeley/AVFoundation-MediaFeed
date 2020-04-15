//
//  CoreDataManager.swift
//  AvFoundation-MediaFeed
//
//  Created by Gregory Keeley on 4/14/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    private init() {}
    static let shared = CoreDataManager()
    private var mediaObjects = [CDMediaObject]()
    // Get instance of the NSManagedObjectContext from the appDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // NSManagedOjbectContet does saving, fetching on NSMANagedObjects
    func create(_ imageData: Data, videoURL: URL?) -> CDMediaObject {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        mediaObject.createdDate = Date()
        mediaObject.id = UUID().uuidString
        mediaObject.imageData = imageData
        if let videoURL = videoURL { // If this exists, we know it is a video object
            do {
            mediaObject.videoData = try Data(contentsOf: videoURL)
            } catch {
                print("failed to convert URL to data with error: \(error)")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("failed to save newly created mediaObject: \(error)")
        }
        return mediaObject
    }
    
    func fetchMediaObject() -> [CDMediaObject] {
        do {
            mediaObjects = try context.fetch(CDMediaObject.fetchRequest())
        } catch {
            print("failed to fetch media objects with error: \(error)")
        }
        return mediaObjects
    }
    
}
