//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 20/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    /// This point will be used for the swipe down gesture (dismiss the viewcontroller with style)
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)

    @IBOutlet weak var dismisButton: UIButton!
    @IBOutlet weak var backgroundArtworkView: UIImageView!
    @IBOutlet weak var artworkView: UIImageView!
    
    public var viewModel : PlayerViewModel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipBackButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.backgroundArtworkView.addBlur(style: .dark)
        self.backgroundArtworkView.contentMode = .scaleAspectFill
        self.artworkView.contentMode = .scaleAspectFill
        self.artworkView.clipsToBounds = true
        self.artworkView.layer.cornerRadius = 4
        self.playButton.imageView?.contentMode = .scaleAspectFit
        self.skipBackButton.imageView?.contentMode = .scaleAspectFit
        self.skipForwardButton.imageView?.contentMode = .scaleAspectFit
        self.dismisButton.imageView?.contentMode = .scaleAspectFit
        
        self.configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.userDidTapPlayButton()
    }
    
    private func configureView() {
        
        // Color
        
        self.artistLabel.textColor = self.viewModel.attr.artistTitleColor
        self.trackLabel.textColor = self.viewModel.attr.trackTitleColor
        self.artworkView.backgroundColor = self.viewModel.attr.backgroundColor
        self.progressView.progressTintColor = .white
        self.progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.3)
        self.currentTimeLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        self.maxTimeLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        self.playButton.tintColor = .white
        self.skipBackButton.tintColor = .white
        self.skipForwardButton.tintColor = .white
        
        self.dismisButton.tintColor = .white
        
        // Fonts
        
        self.trackLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.artistLabel.font = UIFont.systemFont(ofSize: 15)
        self.currentTimeLabel.font = UIFont.systemFont(ofSize: 13)
        self.maxTimeLabel.font = UIFont.systemFont(ofSize: 13)
        
        // Content
        
        self.trackLabel.text = viewModel.title
        self.artistLabel.text = viewModel.artistName
        self.artworkView.kf.setImage(with: viewModel.artworkURL)
        self.backgroundArtworkView.kf.setImage(with: viewModel.artworkURL)
        self.currentTimeLabel.text = 0.toFormattedString()
        self.maxTimeLabel.text = 30.toFormattedString()
        self.progressView.progress = 0.0
        
        self.skipBackButton.setTitle("", for: .normal)
        self.skipBackButton.setImage(#imageLiteral(resourceName: "skipBackIcon"), for: .normal)

        self.skipForwardButton.setTitle("", for: .normal)
        self.skipForwardButton.setImage(#imageLiteral(resourceName: "skipForwardIcon"), for: .normal)
        
        self.playButton.setTitle("", for: .normal)
        self.playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)

        self.dismisButton.setTitle("", for: .normal)
        self.dismisButton.setImage(#imageLiteral(resourceName: "dismissIcon"), for: .normal)

    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        viewModel.userDidTapPlayButton()
    }
    
    /// When the user swipe down the view will follow his gesture and can be dismissed by it.
    @IBAction func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        switch sender.state {
            
        case .began:
            initialTouchPoint = touchPoint
            
        case .changed:
            if touchPoint.y - initialTouchPoint.y > 0 {
                // Move view according to swipe gesture
                self.view.frame = CGRect(x: 0,
                                         y: touchPoint.y - initialTouchPoint.y,
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
            }
            
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Animate back to orginial position
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        default:
            break
        }
    }
}

extension PlayerViewController : PlayerViewModelDelegate {
    func playerViewModelDidStartPlaying(model: PlayerViewModel) {
        self.playButton.setImage(#imageLiteral(resourceName: "pauseIcon"), for: .normal)
    }
    
    func playerViewModelDidStopPlaying(model: PlayerViewModel) {
        self.playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
    }
    
    func playerViewModel(model: PlayerViewModel, didUpdate time: PlayerTime) {
        self.progressView.progress = time.progress
        self.currentTimeLabel.text = time.currentTime
    }
}
