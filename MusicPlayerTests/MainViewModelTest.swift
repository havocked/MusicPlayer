//
//  MainViewModelTest.swift
//  MusicPlayerTests
//
//  Created by Nataniel Martin on 25/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import MusicPlayer

class MainViewModelTest: XCTestCase {
    
    var viewModel = MainViewModel()
    var lastReceivedEvent: MainEvent?
    var lastReceivedError: MSError?
    
    override func setUp() {
        super.setUp()
        lastReceivedError = nil
        lastReceivedEvent = nil
        viewModel = MainViewModel(networkRessource: NetworkMockTest())
        viewModel.delegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCharts() {
        viewModel.getTopCharts()
        XCTAssertEqual(viewModel.totalCharts, 1)
        XCTAssertEqual(viewModel.totalSongs(for: 0), 25)
        XCTAssertEqual(viewModel.nameForSection(0), "Classement des morceaux")
        XCTAssertEqual(lastReceivedEvent, MainEvent.update)
    }
    
    func testCellModel() {
        viewModel.getTopCharts()
        let model = viewModel.songCellModel(for: IndexPath(row: 0, section: 0))
        XCTAssertEqual(model.artistName, "Aya Nakamura")
        XCTAssertEqual(model.imageUrl?.absoluteString, "https://is5-ssl.mzstatic.com/image/thumb/Music128/v4/5d/a0/a6/5da0a6bd-3942-a34f-e08b-41e4271cf969/source/300x300bb.jpg")
        XCTAssertEqual(model.songTitle, "Djadja")
    }
    
    func testPlayViewModel() {
        viewModel.getTopCharts()
        let model = viewModel.userDidSelectCell(at: IndexPath(row: 2, section: 0))
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.artistName, "L'Algérino")
        XCTAssertEqual(model?.artworkURL?.absoluteString, "https://is3-ssl.mzstatic.com/image/thumb/Music118/v4/67/73/db/6773dbad-f17f-d5ac-20ae-fade4e82bb1d/source/500x500bb.jpg")
        XCTAssertEqual(model?.previewURL.absoluteString, "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview128/v4/3e/77/63/3e7763c4-fd7c-7215-e0a3-319ac4dfccb6/mzaf_3602700619913679267.plus.aac.p.m4a")
        XCTAssertEqual(model?.title, "Va Bene")
    }
}

extension MainViewModelTest : MainViewModelDelegate {
    func mainViewModel(model: MainViewModel, didSend event: MainEvent) {
        lastReceivedEvent = event
    }
    
    func mainViewModel(model: MainViewModel, showError error: MSError) {
        lastReceivedError = error
    }
}
