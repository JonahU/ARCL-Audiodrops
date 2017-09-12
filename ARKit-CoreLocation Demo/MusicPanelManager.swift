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
    
    init(viewController: ViewController){
        self.viewController = viewController
    }
    
    private func showHidePanel(hide: Bool, animated: Bool){
        if !animated {
            viewController.trackLabel.isHidden = hide
            return
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        self.viewController.trackLabel.isHidden = hide
                        self.updatePanelVisibility()
        }, completion: nil)
    }
    
    private func updatePanelVisibility() {
        viewController.musicPanel.isHidden = viewController.trackLabel.isHidden
    }
}
