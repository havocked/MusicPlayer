//
//  Song.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 24/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

struct Song : Codable {
    
    var id: String
    var previews: [Preview]
    var artwork: Artwork
    var artistName: String
    var name: String
    
    private enum AttributesCodingKeys: String, CodingKey {
        case previews
        case artwork
        case artistName
        case name
    }
    
    private enum SongCodingKeys: String, CodingKey {
        case id
        case attributes
    }
    
    public init(from decoder: Decoder) throws {
        let allValues = try decoder.container(keyedBy: SongCodingKeys.self)
        id = try allValues.decode(String.self, forKey: .id)
        
        let attributeValues = try allValues.nestedContainer(
            keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        previews = try attributeValues.decode([Preview].self, forKey: .previews)
        artwork = try attributeValues.decode(Artwork.self, forKey: .artwork)
        artistName = try attributeValues.decode(String.self, forKey: .artistName)
        name = try attributeValues.decode(String.self, forKey: .name)
    }
    
}
