//
//  AudioDrop.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/5/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioDrop: NSObject {
    var player: AVAudioPlayer?
    
    let audioPath: URL! = Bundle.main.url(forResource: "song", withExtension: "mp3")
    
    var albumArt: UIImage?
    var trackName: String?
    var artistName: String?
    var albumName: String?
    
    var song: Song!
    
    var downloadTask: URLSessionDownloadTask?
    
    required init?(coder aDecoder: NSCoder) {
       super.init()
    }
    
    func updateAlbumArt() {
        song.artworkLoaded = false
        if song.artworkURL.range(of: "http") != nil {
            if let url = URL(string: song.artworkURL) {
                
            }
        }
    }
    
    
    
    //TO DO: REORGANISE ME
    func playSong() {
        song.isPlaying = true
        
        guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pauseSong() {
        song.isPlaying = false
    }
}
