//
//  Song.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/8/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

struct Song{
    var title: String = ""
    var artist: String = ""
    //var album: String = ""
    var artworkURL: String = ""
    var artworkImage : UIImage? = UIImage(named: "defaultAlbumArt")
    var artworkLoaded : Bool = false
    var isPlaying : Bool = false
    
    init(title: String, artist: String, artworkURL: String){
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        artworkLoaded = false
        isPlaying = false
    }
}

extension Song: CustomStringConvertible {
    var description: String{
        return "title: \(title), artist: \(artist), artworkURL: \(artworkURL)"
    }
}
