//
//  GamePlayViewModel.swift
//  DiceDiceBaby
//
//  Created by glnygl on 30.07.2023.
//

import SwiftUI
import AVFoundation
import Foundation

enum DiceType: String {
    case pink
    case purple
}

enum GameState {
    case start
    case pinkTurn
    case purpleTurn
    case end
}

enum GameResult {
    case pinkWin
    case purpleWin
    case tie
}

class GamePlayViewModel: ObservableObject {
    
    @Published var titleText = LocalizableStrings.Default.start
    
    var diceSound: AVAudioPlayer = AVAudioPlayer ()
    var winSound: AVAudioPlayer = AVAudioPlayer ()
    
    var timer: Timer?
    
    @Published var pinkDiceResult = 6
    @Published var purpleDiceResult = 6
    
    @Published var pinkDicePlayed = false
    @Published var purpleDicePlayed = false
    @Published var rollingDice = false
    
    @Published var gameState: GameState = .start
    @Published var gameResult: GameResult?
    
    var randomImageNumbers : [Int] = []
    
    func roll(type: DiceType) {
        rollingDice = true
        animateDice(type: type) { [weak self] _ in
            guard let self = self else { return }
            self.checkGameState()
            self.rollingDice = false
        }
    }
    
    func checkGameState() {
        if pinkDicePlayed && !purpleDicePlayed {
            gameState = .purpleTurn
            titleText = getStateText()
        } else if !pinkDicePlayed && purpleDicePlayed {
            gameState = .pinkTurn
            titleText = getStateText()
        } else {
            gameState = .end
            gameResult = calculateGameResult()
            resetDiceStates()
        }
    }
    
    func calculateGameResult() -> GameResult {
        if pinkDiceResult > purpleDiceResult {
            return .pinkWin
        } else if purpleDiceResult > pinkDiceResult {
            return .purpleWin
        } else {
            return .tie
        }
    }
    
    func resetDiceStates() {
        titleText = getResultText()
        self.pinkDicePlayed = false
        self.purpleDicePlayed = false
    }
    
    func getStateText() -> String {
        switch gameState {
        case .start:
            return LocalizableStrings.Default.start
        case .pinkTurn:
            return LocalizableStrings.Turn.pinkTurn
        case .purpleTurn:
            return LocalizableStrings.Turn.purpleTurn
        case .end:
            return ""
        }
    }
    
    func getResultText() -> String {
        switch gameResult {
        case .pinkWin:
            return LocalizableStrings.Result.pinkWin
        case .purpleWin:
            return LocalizableStrings.Result.purpleWin
        case .tie:
            return LocalizableStrings.Result.tie
        case .none:
            return ""
        }
    }
    
    func animateDice(type: DiceType, completion: @escaping (Bool) -> Void) {
        
        if type == .pink { pinkDicePlayed = true } else { purpleDicePlayed = true  }
        
        randomImageNumbers = []
        for _ in 1...6 {
            let random = Int.random(in: 1...6)
            randomImageNumbers.append(random)
        }
        
        var index = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self ] (Timer) in
            guard let self = self else { return }
            if (index < self.randomImageNumbers.count) {
                if type == .pink {
                    self.pinkDiceResult = self.randomImageNumbers[index]
                } else {
                    self.purpleDiceResult = self.randomImageNumbers[index]
                }
                index += 1
            } else {
                self.timer?.invalidate()
                completion(true)
            }
        }
    }
    
    func getImageName(type: DiceType) -> String {
        let result = (type == .pink) ? pinkDiceResult : purpleDiceResult
        return "\(type.rawValue)\(result)"
    }
    
    func getGameSounds() {
        let soundFile = Bundle.main.path(forResource: "DiceSoundEffect", ofType: ".mp3")
        let winFile = Bundle.main.path(forResource: "WinSoundEffect", ofType: ".mp3")
        do {
            try diceSound = AVAudioPlayer(contentsOf: URL (fileURLWithPath: soundFile!))
        }
        catch {
            print("Dice sound failed")
        }
        
        do {
            try winSound = AVAudioPlayer(contentsOf: URL (fileURLWithPath: winFile!))
        }
        catch {
            print("Win sound failed")
        }
    }
    
}

