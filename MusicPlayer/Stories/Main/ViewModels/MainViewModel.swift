//
//  MainViewModel.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 20/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

protocol MainViewModelDelegate: class {
    func mainViewModel(model: MainViewModel, didSend event: MainEvent)
    func mainViewModel(model: MainViewModel, showError error: MSError)
}

enum MainEvent {
    case update
}

final class MainViewModel: NSObject {
    
    private var networkManager : NetworkRessource
    private var searchTask : DispatchWorkItem?
    private var fetchedCharts = [ChartResult<Song>]()
    
    public weak var delegate : MainViewModelDelegate?
    
    var totalCharts : Int {
        get {
            return fetchedCharts.count
        }
    }
    
    // MARK: Public methods
    
    init(networkRessource: NetworkRessource = NetworkManager()) {
        // Use Mock response when UI testing
        if let _ = ProcessInfo.processInfo.environment["-ShouldMockResponse"] {
            networkManager = NetworkMockTest()
        } else {
            networkManager = networkRessource
        }
    }
    
    public func getTopCharts() {
        let storeFront = Locale.current.languageCode ?? "FR"
        networkManager.getTopCharts(storeFront: storeFront, completionHandler: { charts in
            self.fetchedCharts = charts
            self.delegate?.mainViewModel(model: self, didSend: .update)
        }) { error in
            self.delegate?.mainViewModel(model: self, showError: error)
        }
    }
    
    func songCellModel(for indexpath: IndexPath) -> SongCellModel {
        let song = fetchedCharts[indexpath.section].data[indexpath.row]
        let model = SongCellModel(song: song)
        return model
    }
    
    func userDidSelectCell(at indexpath: IndexPath) -> PlayerViewModel? {
        let song = fetchedCharts[indexpath.section].data[indexpath.row]
        do {
            let model = try PlayerViewModel(song: song)
            return model
        } catch {
            let err = MSError.message(title: "ERROR_ALERT_TITLE".localized, message: "ERROR_NO_PREVIEW".localized)
            self.delegate?.mainViewModel(model: self, showError: err)
            return nil
        }
       
    }
    
    func totalSongs(for section: Int) -> Int {
        return fetchedCharts[section].data.count
    }
    
    func nameForSection(_ section: Int) -> String {
        return fetchedCharts[section].name
    }
}
