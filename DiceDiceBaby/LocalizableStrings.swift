//
//  LocalizableStrings.swift
//  DiceDiceBaby
//
//  Created by glnygl on 1.08.2023.
//

import Foundation

struct LocalizableStrings {
    
    struct Default {
        static let start = "start".localize()
    }
    
    struct Turn {
        static let purpleTurn = "purpleTurn".localize()
        static let pinkTurn = "pinkTurn".localize()
    }

    struct Result {
        static let purpleWin = "purpleWin".localize()
        static let pinkWin = "pinkWin".localize()
        static let tie = "tie".localize()
    }
    
}

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
