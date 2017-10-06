//
//  NodeManager.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/13/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import Foundation
import ARKit

class NodeManager {
    var nodes = [Drop]()
    
    var lastUsedNode: Drop?
    
    // The queue with updates to the virtual objects are made on.
    var updateQueue: DispatchQueue
    
    init(updateQueue: DispatchQueue){
        self.updateQueue = updateQueue
    }
    
    func removeAllNodes(){
        for node in nodes{
            unloadNode(node)
        }
        nodes.removeAll()
    }
    
    func removeNode(at index: Int) {
        //let definition = NodeManager.
    }
    
    private func unloadNode(_ node: Drop){
        updateQueue.async {
            //if scenereferencenode, node.unload()
            node.removeFromParentNode()
            if self.lastUsedNode == node {
                self.lastUsedNode = nil
                if self.nodes.count > 1 {
                    self.lastUsedNode = self.nodes[0]
                }
            }
        }
    }
}
