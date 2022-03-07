//
//  ViewController.swift
//  AVPlayerViewController-Subtitles
//
//  Created by mhergon on 23/12/15.
//  Copyright © 2015 mhergon. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAssetResourceLoaderDelegate {
    
    // MARK: - Actions
    lazy var player: AVPlayer = {
     
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
     
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
     
        return player
    }()
     
    lazy var playerItem: AVPlayerItem = {
     
        var playerItem: AVPlayerItem = AVPlayerItem(asset: self.asset)
     
        return playerItem
    }()
     
    lazy var asset: AVURLAsset = {
     
        var asset: AVURLAsset = AVURLAsset(url: self.url)
     
        return asset
    }()
     
    lazy var playerLayer: AVPlayerLayer = {
     
        var playerLayer: AVPlayerLayer = AVPlayerLayer(player: self.player)
     
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
     
        return playerLayer
    }()
     
    var url: URL = {
     
        var url = URL(string:"https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-Video-File-For-Testing.mp4")
     
        return url!
    }()
    
    private let movieName = "trailer_720p"
    @IBAction func showVideo(_ sender: UIButton) {
        // Video file
        let videoFile = Bundle.main.path(forResource: "trailer_720p", ofType: "mov")
        let locolVideoURL =  Bundle.main.url(forResource: "trailer_720p", withExtension: "mov")
        // Remote subtitle file
        let subtitleRemoteUrl = URL(string: "https://raw.githubusercontent.com/furkanhatipoglu/AVPlayerViewController-Subtitles/master/Example/AVPlayerViewController-Subtitles/trailer_720p.srt")
        let settings = [
                                AVFormatIDKey: kAudioFormatAppleLossless,
                                AVSampleRateKey:44100.0,
                                AVNumberOfChannelsKey:2,
            AVEncoderAudioQualityKey:AVAudioQuality.medium.rawValue
        ] as [String : Any]
        
        // Movie player
    
      //  let assset = AVAsset(url: locolVideoURL!)
        let savedPathURL = URL(string: "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8")!
        let composition = AVMutableComposition()

        
        
        let assset = AVURLAsset(url: URL(string: "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-Video-File-For-Testing.mp4")!)
       
        //assset.resourceLoader.delegate = self
        let videoOutputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "\(movieName)saaaasasfasfs.mp4")

        let assetExport:AVAssetExportSession = AVAssetExportSession(asset: assset, presetName: AVAssetExportPresetLowQuality)!
        assetExport.outputFileType = .mp4
        assetExport.outputURL = videoOutputUrl
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously {
            switch assetExport.status {
            
            
            case .completed:
                print("Status Completed,",videoOutputUrl)
                DispatchQueue.main.async {
                    // Present a UIActivityViewController to share audio file
                    guard let outputURl = assetExport.outputURL else { return }
                    print("Status Completed,",outputURl)
                    let moviePlayer = AVPlayerViewController()
                        let outputAssset = AVAsset(url: outputURl)
                    let avItem = AVPlayerItem(asset: outputAssset)
                    //avItem.videoComposition?.frameDuration = .init()
                    if #available(iOS 11.0, *) {
                        //avItem.preferredMaximumResolution = .init()
                    } else {
                        // Fallback on earlier versions
                    }
                   //avItem.preferredPeakBitRate = 2388608
                    moviePlayer.player = .init(playerItem: avItem)
                    
                   // moviePlayer.player = AVPlayer(url: URL)
                    self.present(moviePlayer, animated: true, completion: nil)
                    
                    // Local subtitle file
                    let subtitleFile = Bundle.main.path(forResource: "trailer_720p", ofType: "srt")
                    let subtitleURL = URL(fileURLWithPath: subtitleFile!)
                    
                    // Add subtitles - local
                    moviePlayer.addSubtitles()
                    
                        try? moviePlayer.open(fileFromLocal: subtitleURL)
                   // moviePlayer.addSubtitles().open(fileFromLocal: subtitleURL, encoding: .utf8)
                    
                    // Add subtitles - remote
                 //   moviePlayer.addSubtitles()
                   // moviePlayer.open(fileFromRemote: subtitleRemoteUrl!)
                    
                    // Change text properties
                    moviePlayer.subtitleLabel?.textColor = UIColor.systemGreen
                    
                    // Playmo
                    moviePlayer.player?.play()
                    
                }
                
                
            case .failed:
                print(" Status Faild",assetExport.error!)
            case .cancelled:
                print(" Status Canceled",assetExport.error?.localizedDescription)

             default:
                print("defualt",assetExport.error)
            }
        }
       
    }
    
    func subtitleParser() {
        // Subtitle file
        let subtitleFile = Bundle.main.path(forResource: "trailer_720p", ofType: "srt")
        let subtitleURL = URL(fileURLWithPath: subtitleFile!)
        
        // Subtitle parser
        let parser = try? Subtitles(file: subtitleURL, encoding: .utf8)
        
        // Do something with result
        _ = parser?.searchSubtitles(at: 2.0) // Search subtitle at 2.0 seconds
    }
    
}
