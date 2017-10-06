//
//  MusicManager.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/12/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import Foundation
import UIKit

class MusicPanelManager {
    
    private var viewController: ViewController!
    
    var progress: Timer?
    
    init(viewController: ViewController){
        self.viewController = viewController
    }
    
    func showNewMusicInfo(trackName: String, artistName: String){
        progress = Timer.scheduledTimer(timeInterval: 1.0,
                                        target: self,
                                        selector: #selector(MusicPanelManager.updateProgress),
                                        userInfo: nil,
                                        repeats: true)
        
        DispatchQueue.main.async {
            self.viewController.view.bringSubview(toFront: self.viewController.musicPanel)
            self.viewController.trackLabel.text = "\(trackName) - \(artistName)"
            self.viewController.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            self.viewController.musicProgressSlider.value = Float(self.viewController.audioPlayer.currentTime/self.viewController.audioPlayer.duration)
            self.showHidePanel(hide: false, animated: true)
        }
    }
    
    @objc func updateProgress(){
        let musicIsPlaying = viewController.audioPlayer.isPlaying
        
        let current = self.viewController.audioPlayer.currentTime
        let total = self.viewController.audioPlayer.duration
        
        DispatchQueue.main.async {
            if musicIsPlaying{
                self.viewController.musicProgressSlider.value = Float(current/total)
            } else if current == 0 {
                self.progress?.invalidate()
                self.showHidePanel(hide: true, animated: true)
            }
        }
    }
    
    @objc func updateProgressManually(value: Float){
        if value == 1.0 {
            DispatchQueue.main.async {
                self.progress?.invalidate()
                self.showHidePanel(hide: true, animated: true)
                self.viewController.audioPlayer.stop()
            }
        } else {
            let total = viewController.audioPlayer.duration
            let newValue = TimeInterval(value)*total
        
            viewController.audioPlayer.pause()
            viewController.audioPlayer.currentTime = newValue
            viewController.audioPlayer.play()
        }
    }
    
    func pause(){
        DispatchQueue.main.async {
            self.viewController.playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    func play(){
        DispatchQueue.main.async {
            self.viewController.playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
        }
    }
    
    private func showHidePanel(hide: Bool, animated: Bool){
        if !animated {
            viewController.trackLabel.isHidden = hide
            viewController.playPauseButton.isHidden = hide
            viewController.musicProgressSlider.isHidden = hide
            viewController.musicPanel.isHidden = hide
            return
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        self.viewController.trackLabel.isHidden = hide
                        self.viewController.playPauseButton.isHidden = hide
                        self.viewController.musicProgressSlider.isHidden = hide
                        self.viewController.musicPanel.isHidden = hide
                        self.updatePanelVisibility()
        }, completion: nil)
    }
    
    private func updatePanelVisibility() {
        viewController.musicPanel.isHidden = viewController.trackLabel.isHidden
    }
}
