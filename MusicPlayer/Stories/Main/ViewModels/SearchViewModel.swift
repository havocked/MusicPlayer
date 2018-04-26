//
//  SearchViewModel.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 25/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: class {
    func searchViewModel(model: SearchViewModel, didSend event: SearchEvent)
    func searchViewModel(model: SearchViewModel, showError error: MSError)
}

enum SearchEvent {
    case update
}

final class SearchViewModel: NSObject {
    
    private var searchTask : DispatchWorkItem?
    private var fetchedSongs : SearchResult<Song>?
    public weak var delegate : SearchViewModelDelegate?
    
    var totalSongs : Int {
        get {
            return fetchedSongs?.data.count ?? 0
        }
    }
    
    
    // MARK: Public methods
    
    func songCellModel(for indexpath: IndexPath) -> SongCellModel {
        let song = fetchedSongs!.data[indexpath.row]
        let model = SongCellModel(song: song)
        return model
    }
    
    func userDidSelectCell(at indexpath: IndexPath) -> PlayerViewModel? {
        let song = fetchedSongs!.data[indexpath.row]
        do {
            let model = try PlayerViewModel(song: song)
            return model
        } catch {
            let err = MSError.message(title: "ERROR_ALERT_TITLE".localized, message: "ERROR_NO_PREVIEW".localized)
            self.delegate?.searchViewModel(model: self, showError: err)
            return nil
        }
        
    }
}

extension SearchViewModel : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.trimWhitespaces().replacingOccurrences(of: " ", with: "+"), text.count > 0 {
            searchTask?.cancel()
            searchTask = DispatchWorkItem {
                let storeFront = Locale.current.languageCode ?? "FR"
                NetworkManager.default.search(query: text, storeFront: storeFront, completionHandler: { (result: SearchResult<Song>) in
                    self.fetchedSongs = result
                    self.delegate?.searchViewModel(model: self, didSend: .update)
                }) { [unowned self] (error) in
                    self.delegate?.searchViewModel(model: self, showError: error)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: searchTask!)
        }
    }
}
