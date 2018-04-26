//
//  TimeInterval+Extension.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 25/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toFormattedString() -> String {
        let hours = (Int(self) / 3600)
        let minutes = Int(self / 60) - Int(hours * 60)
        let seconds = Int(self) - (Int(self / 60) * 60)
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

extension Int {
    func toFormattedString() -> String {
        let hours = (Int(self) / 3600)
        let minutes = Int(self / 60) - Int(hours * 60)
        let seconds = Int(self) - (Int(self / 60) * 60)
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
