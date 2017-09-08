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
import SceneKit
import CoreLocation


class AudioDrop: LocationNode {
    
//    let audioPath: URL! = Bundle.main.url(forResource: "song", withExtension: "mp3")
    let song: Song
    let albumArt: UIImage
    
    let audioNode: SCNNode

    var scaleRelativeToDistance = false //currently doesnt work, edit SceneLocationView to fix
    
    //Audio Player
    var player: AVAudioPlayer!
    
    init(location: CLLocation?, song: Song) {
        self.song = song
        albumArt = song.artworkImage!
        
        let plane = SCNPlane(width: albumArt.size.width / 10, height: albumArt.size.height / 10)
        plane.firstMaterial!.diffuse.contents = albumArt
        plane.firstMaterial!.lightingModel = .constant
        
        audioNode = SCNNode()
        audioNode.geometry = plane
        
        super.init(location: location)
        self.continuallyAdjustNodePositionWhenWithinRange = false
                
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(audioNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playSong(){
        do{
            if let url = Bundle.main.url(forResource: "song", withExtension: "mp3"){
                self.player = try AVAudioPlayer(contentsOf: url)
                self.player.play()
            }
            
        } catch let error as NSError{
            print(error.description)
        }
    }
    
    //TO DO: REORGANISE ME
//    func playSong() {
//        song.isPlaying = true
//
//        guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
//            print("asset not found")
//            return
//        }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url)
//            guard let player = player else { return }
//
//            player.play()
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//
//    func pauseSong() {
//        song.isPlaying = false
//    }
}
