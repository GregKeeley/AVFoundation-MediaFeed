//
//  ViewController.swift
//  AvFoundation-MediaFeed
//
//  Created by Gregory Keeley on 4/13/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import AVFoundation // Video playback is done on a CALayer
import AVKit // Video playback is done iusing the AVPlayerViewController

class MediaFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!

    private lazy var imagePickerController:
        UIImagePickerController = {
            let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
            
        let pickerController = UIImagePickerController()
            pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
            pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObject]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoButton.isEnabled = false
        }

    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    @IBAction func photoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    private func playRandomVideo(in view: UIView) {
        // We want all non-nil media object from the mediaObject array (compactMap)
        let videoUrls = mediaObjects.compactMap { $0.videoURL }
        // Getting a random video URL
        if let videoURL = videoUrls.randomElement() {
            let player = AVPlayer(url: videoURL)
            // create a sublayer for the random video
            let playerLayer = AVPlayerLayer(player: player)
            // set its frame
            playerLayer.frame = view.bounds // take up the entire headerView
            // Set video aspect ratio
            playerLayer.videoGravity = .resizeAspectFill
            // remove all sublayers from the headerView
            view.layer.sublayers?.removeAll()
            view.layer.addSublayer(playerLayer)
            // add the playerLayer to the headerViews layer
            player.play()
        }
    }
}
extension MediaFeedViewController: UICollectionViewDelegate {
    
}
extension MediaFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("failed to dequeue as MediaCell")
        }
        let mediaObject = mediaObjects[indexPath.row]
        cell.configureCell(for: mediaObject)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("could not dequeue")
        }
        playRandomVideo(in: headerView)
        return headerView
    }
}
extension MediaFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaObjects[indexPath.row]
          guard let videoURL = mediaObject.videoURL else {
            return
          }
          let playerViewController = AVPlayerViewController()
          let player = AVPlayer(url: videoURL)
          playerViewController.player = player
          present(playerViewController, animated: true) {
            player.play()
          }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.50
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    // Sets size for the headerView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40)
    }
}
extension MediaFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // InfoKey.originalImage
        // InfoKey.mediaType
        // InfoKey.mediaURL
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let imageData = originalImage.jpegData(compressionQuality: 1.0)
                let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject)
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                let mediaObject = MediaObject(imageData: nil, videoURL: mediaURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("Unsupported Media type")
        }
        print("mediaType: \(mediaType)")
        picker.dismiss(animated: true)
    }
}
