//
//  LibraryAPI.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 9/8/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import Foundation

final class LibraryAPI {
    static let shared = LibraryAPI()
    private let dummyData = DummyData()
    private let httpClient = HTTPClient()
    private let isOnline = false
    
    private init() {
        
    }
    
    func getSongs() -> [Song]{
        return dummyData.getSongs()
    }
    
    func addSong(_ song: Song, at index: Int){
        dummyData.addSong(song, at: index)
        if isOnline{
            httpClient.postRequest("/api/addAlbum", body: song.description)
        }
    }
    
    func deleteSong(at index: Int){
        dummyData.deleteSong(at: index)
        if isOnline{
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    
}
