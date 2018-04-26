//
//  SearchViewController.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 25/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SongCell.self)
        viewModel.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalSongs
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SongCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let model = viewModel.songCellModel(for: indexPath)
        cell.configure(with: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let playerViewModel = viewModel.userDidSelectCell(at: indexPath) {
            let storyboard = UIStoryboard(name: "Player", bundle: nil)
            let vc : PlayerViewController = storyboard.instantiateViewController(withIdentifier: "playerViewController") as! PlayerViewController
            vc.viewModel = playerViewModel
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension SearchViewController : SearchViewModelDelegate {
    func searchViewModel(model: SearchViewModel, didSend event: SearchEvent) {
        switch event {
        case .update:
            self.tableView.reloadData()
        }
    }
    
    func searchViewModel(model: SearchViewModel, showError error: MSError) {
        let alert = UIAlertController(title: "ERROR_ALERT_TITLE".localized, message: error.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ALERT_OK_ACTION_TITLE".localized, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
