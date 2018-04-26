//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 20/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MAIN_NAV_TITLE".localized
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.register(SongCell.self)
        self.addSearchbar()
        self.addRefreshControl()
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.totalCharts == 0 {
            viewModel.getTopCharts()
        }
    }
    
    func addRefreshControl() {
        // Add refresh control to TableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func addSearchbar() {
        let searchController = SearchViewController()
        let search = UISearchController(searchResultsController: searchController)
        search.searchResultsUpdater = searchController.viewModel
        search.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        self.navigationItem.searchController = search
    }
    
    @objc private func refreshAction() {
        viewModel.getTopCharts()
    }
    
    
    // MARK: UITableViewController Delegates / Datasources
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.totalCharts
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalSongs(for: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.nameForSection(section)
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

extension MainViewController : MainViewModelDelegate {
    func mainViewModel(model: MainViewModel, didSend event: MainEvent) {
        switch event {
        case .update:
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func mainViewModel(model: MainViewModel, showError error: MSError) {
        self.tableView.refreshControl?.endRefreshing()
        
        let alert = UIAlertController(title: "ERROR_ALERT_TITLE".localized, message: error.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ALERT_OK_ACTION_TITLE".localized, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
