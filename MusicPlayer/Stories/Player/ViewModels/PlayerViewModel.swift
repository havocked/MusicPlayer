//
//  PlayerViewModel.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 24/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit
import KDEAudioPlayer

public enum PlayerViewModelError: Error {
    case noPreviewUrl
}

protocol PlayerViewModelDelegate : class {
    func playerViewModelDidStartPlaying(model : PlayerViewModel)
    func playerViewModelDidStopPlaying(model : PlayerViewModel)
    func playerViewModel(model: PlayerViewModel, didUpdate time: PlayerTime)
}

public struct PlayerTime {
    var progress: Float
    var currentTime: String
}

struct PlayerAttributes {
    var backgroundColor: UIColor
    var artistTitleColor: UIColor
    var trackTitleColor: UIColor
    var progressColor: UIColor
    var timeLabelColor: UIColor
    
    init(artwork: Artwork) {
        backgroundColor = UIColor(hexString: artwork.bgColor)
        artistTitleColor = UIColor(hexString: artwork.textColor1)
        trackTitleColor = UIColor(hexString: artwork.textColor2)
        progressColor = UIColor(hexString: artwork.textColor3)
        timeLabelColor = UIColor(hexString: artwork.textColor4)
    }
}

final class PlayerViewModel : NSObject {
    
    private var audioPlayer = AudioPlayer()
    public var title: String
    public var artistName: String
    public var artworkURL: URL?
    public var attr: PlayerAttributes
    public var previewURL: URL
    
    public weak var delegate: PlayerViewModelDelegate?
    
    public init(song: Song) throws {
        
        title = song.name
        artistName = song.artistName
        let artworkUrlString = song.artwork.url.replacingOccurrences(of: "{w}", with: "\(500)").replacingOccurrences(of: "{h}", with: "\(500)")
        artworkURL = URL(string: artworkUrlString)
        attr = PlayerAttributes(artwork: song.artwork)
        
        guard let urlString = song.previews.first?.url, let url = URL(string: urlString) else {
            throw PlayerViewModelError.noPreviewUrl
        }
        previewURL = url
        
        super.init()
        audioPlayer.delegate = self
    }

    public func userDidTapPlayButton() {
        switch audioPlayer.state {
        case .buffering, .playing, .failed:
            audioPlayer.pause()
        case .paused:
            audioPlayer.resume()
        case .stopped:
            if let item = AudioItem(mediumQualitySoundURL: previewURL) {
                audioPlayer.play(item: item)
            }
        default:
            break
        }
    }
}

extension PlayerViewModel : AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        let time = PlayerTime(progress: percentageRead / 100, currentTime: time.toFormattedString())
        self.delegate?.playerViewModel(model: self, didUpdate: time)
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        switch state {
        case .playing,. buffering, .waitingForConnection:
            self.delegate?.playerViewModelDidStartPlaying(model: self)
        case .stopped, .paused, .failed:
            self.delegate?.playerViewModelDidStopPlaying(model: self)
        }
    }
}
