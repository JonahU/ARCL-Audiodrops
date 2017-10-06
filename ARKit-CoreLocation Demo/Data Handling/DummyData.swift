//
//  DummyData.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/8/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import Foundation

final class DummyData {
    private var songs = [Song]()
    
    init() {
        //Dummy list of albums
        let song1 = Song(title: "444",
                           artist: "Jay-Z",
                           artworkURL: "")
        
        let song2 = Song(title: "I Still Love Her",
                           artist: "Teriyaki Boyz",
                           artworkURL: "")
        
        let song3 = Song(title: "Come Together",
                           artist: "Beatles",
                           artworkURL: "")
        
        let song4 = Song(title: "Candy Shop",
                           artist: "50 Cent",
                           artworkURL: "")
        
        let song5 = Song(title: "Leave Your Love Alone",
                           artist: "D-Toks",
                           artworkURL: "")
        
        songs = [song1, song2, song3, song4, song5]
    }
    
    func getSongs() -> [Song] {
        return songs
    }
    
    func addSong(_ song: Song, at index: Int) {
        if (songs.count >= index) {
            songs.insert(song, at: index)
        } else {
            songs.append(song)
        }
    }
    
    func deleteSong(at index: Int) {
        songs.remove(at: index)
    }
    
}
