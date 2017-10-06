//
//  Drop.swift
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

//Song + Location + UserInfo
class Drop: LocationNode {
    
    let song: Song
    
    let albumArt: UIImage
    
    let sceneKitNode: SCNNode

    var scaleRelativeToDistance = false //currently doesnt work, edit SceneLocationView to fix
    
    //Audio Player
    var player: AVAudioPlayer!
    
    init(location: CLLocation?, song: Song) {
        self.song = song
        let songname = song.title
        if let img = UIImage(named: songname){
            albumArt = img
        }else{
            print("error fetching album art")
            albumArt = song.artworkImage!
        }
        
        let plane = SCNPlane(width: albumArt.size.width / 10, height: albumArt.size.height / 10)
        plane.firstMaterial!.diffuse.contents = albumArt
        plane.firstMaterial!.lightingModel = .constant
        
        sceneKitNode = SCNNode()
        sceneKitNode.geometry = plane
        
        super.init(location: location)
        self.continuallyAdjustNodePositionWhenWithinRange = false
                
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(sceneKitNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
