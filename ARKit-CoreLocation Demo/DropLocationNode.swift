//
//  DropLocationNode.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/5/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import Foundation
import SceneKit
import CoreLocation

//MARK: TODO - WORK ON THIS CLASS

class DropLocationNode: LocationNode {
    ///An image to use for the annotation
    ///When viewed from a distance, the annotation will be seen at the size provided
    ///e.g. if the size is 100x100px, the annotation will take up approx 100x100 points on screen.
    public let albumArt: UIImage
    
    ///Subnodes and adjustments should be applied to this subnode
    ///Required to allow scaling at the same time as having a 2D 'billboard' appearance
    public let annotationNode: SCNNode
    
    ///Whether the node should be scaled relative to its distance from the camera
    ///Default value (false) scales it to visually appear at the same size no matter the distance
    ///Setting to true causes annotation nodes to scale like a regular node
    ///Scaling relative to distance may be useful with local navigation-based uses
    ///For landmarks in the distance, the default is correct
    public var scaleRelativeToDistance = false
    
    public init(location: CLLocation?, albumArt: UIImage) {
        self.albumArt = albumArt
        
        let plane = SCNPlane(width: albumArt.size.width / 100, height: albumArt.size.height / 100)
        plane.firstMaterial!.diffuse.contents = albumArt
        plane.firstMaterial!.lightingModel = .constant
        
        annotationNode = SCNNode()
        annotationNode.geometry = plane
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(annotationNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
