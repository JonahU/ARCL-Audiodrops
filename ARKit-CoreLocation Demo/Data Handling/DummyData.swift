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
        let song1 = Song(title: "Best of Bowie",
                           artist: "David Bowie",
                           artworkURL: "https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png")
        
        let song2 = Song(title: "It's My Life",
                           artist: "No Doubt",
                           artworkURL: "https://s3.amazonaws.com/CoverProject/album/album_no_doubt_its_my_life_bathwater.png")
        
        let song3 = Song(title: "Nothing Like The Sun",
                           artist: "Sting",
                           artworkURL: "https://s3.amazonaws.com/CoverProject/album/album_sting_nothing_like_the_sun.png")
        
        let song4 = Song(title: "Staring at the Sun",
                           artist: "U2",
                           artworkURL: "https://s3.amazonaws.com/CoverProject/album/album_u2_staring_at_the_sun.png")
        
        let song5 = Song(title: "American Pie",
                           artist: "Madonna",
                           artworkURL: "https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png")
        
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
