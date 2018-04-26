//
//  SongCellModel.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 20/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct SongCellModel {
    var imageUrl : URL?
    var songTitle : String
    var artistName : String
    
    init(song: Song) {
        
        // We define statically a size for the artwork. But as an improvement, we could definitly passe by parameter the size in the init and dynamically fetch the size of the cell !
        
        let urlString = song.artwork.url.replacingOccurrences(of: "{w}", with: "\(300)").replacingOccurrences(of: "{h}", with: "\(300)")
        imageUrl = URL(string: urlString)
        songTitle = song.name
        artistName = song.artistName
    }
}
