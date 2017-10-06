//
//  ViewController+Actions.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/13/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

extension ViewController{
    
    @IBAction func restartPressed(_ sender: Any){
        guard restartButtonIsEnabled else { return }
        
        DispatchQueue.main.async {
            self.restartButtonIsEnabled = false
            
            /*
             TODO:
             remove all nodes + (mapkit nodes)
            //self.nodeHandler.removeAllNodes()
            
             if music is playing:
             -stop music
             -hide music panel
             */
            
            self.restartButton.setImage(#imageLiteral(resourceName: "restart"), for: [])
            
            // Disable Restart button for a while in order to give the session enough time to restart.
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.restartButtonIsEnabled = true
            })
        
        }
    }
    
    @IBAction func musicProgressSliderSlid(_ sender: UISlider){
        if audioPlayer.isPlaying{
            musicPanelManager.updateProgressManually(value: sender.value)
        }
    }
    
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            audioPlayer.pause()
            musicPanelManager.pause()
        } else{
            audioPlayer.play()
            musicPanelManager.play()
        }
    }
}
