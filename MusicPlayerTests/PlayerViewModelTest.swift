//
//  PlayerViewModelTest.swift
//  MusicPlayerTests
//
//  Created by Nataniel Martin on 25/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import MusicPlayer

class PlayerViewModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        
        let model = try! PlayerViewModel(song: Song())
        XCTAssertEqual(model.artistName, "Yolo")
        XCTAssertEqual(model.artworkURL?.absoluteString, "http://www.test.com/art.jpg")
        XCTAssertEqual(model.previewURL.absoluteString, "http://www.test.com/music.m4a")
        XCTAssertEqual(model.title, "Test")
    }
    
}

extension Song {
    init() {
        self.artistName = "Yolo"
        self.id = "123456789"
        self.name = "Test"

        let testArtwork = Artwork(width: 100,
                                  height: 100,
                                  url: "http://www.test.com/art.jpg",
                                  bgColor: "123445", textColor1: "123445",
                                  textColor2: "123445", textColor3: "123445",
                                  textColor4: "123445")
        self.artwork = testArtwork
        let preview = Preview(url: "http://www.test.com/music.m4a",
                              artwork: testArtwork)
        self.previews = [preview]
    }
}
