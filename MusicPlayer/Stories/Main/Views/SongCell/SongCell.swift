//
//  SongCell.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 20/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit
import Kingfisher

class SongCell: UITableViewCell, EasyRegisteredCell {


    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artworkView.clipsToBounds = true
        artworkView.layer.cornerRadius = 3
        artworkView.backgroundColor = UIColor.purple
        topLabel.font = UIFont.systemFont(ofSize: 17)
        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        bottomLabel.textColor = UIColor.lightGray
    }

    func configure(with model: SongCellModel) {
        self.topLabel.text = model.songTitle
        self.bottomLabel.text = model.artistName
        self.artworkView.kf.setImage(with: model.imageUrl)
    }
    
}
