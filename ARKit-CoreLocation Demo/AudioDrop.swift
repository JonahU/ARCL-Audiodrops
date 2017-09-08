//
//  AudioDrop.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/5/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import AVFoundation

class AudioDrop: NSObject {
    var player: AVAudioPlayer?
    
    //TO DO: REORGANISE ME
    func playSound() {
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
}
