//
//  String+Extension.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 25/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        get {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        }
    }
    
    func localize(args: CVarArg...) -> String {
        return NSString(format: self.localized, arguments: getVaList(args)) as String
    }
    
    func trimWhitespaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
