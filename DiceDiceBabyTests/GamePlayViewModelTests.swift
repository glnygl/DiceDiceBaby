//
//  GamePlayViewModelTests.swift
//  DiceDiceBabyTests
//
//  Created by glnygl on 1.08.2023.
//

import XCTest
import SwiftUI
@testable import DiceDiceBaby

final class GamePlayViewModelTests: XCTestCase {
    
    var viewModel: GamePlayViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = GamePlayViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func test_CheckGameState_PurpleTurn() {
        viewModel.pinkDicePlayed = true
        viewModel.purpleDicePlayed = false
        viewModel.checkGameState()
        XCTAssertEqual(viewModel.gameState, .purpleTurn)
        XCTAssertEqual(viewModel.titleText, LocalizableStrings.Turn.purpleTurn)
    }
    
    func test_CheckGameState_PinkTurn() {
        viewModel.pinkDicePlayed = false
        viewModel.purpleDicePlayed = true
        viewModel.checkGameState()
        XCTAssertEqual(viewModel.gameState, .pinkTurn)
        XCTAssertEqual(viewModel.titleText, LocalizableStrings.Turn.pinkTurn)
    }
    
    func test_CheckGameState_End_PinkWins() {
        viewModel.pinkDicePlayed = true
        viewModel.purpleDicePlayed = true
        viewModel.pinkDiceResult = 6
        viewModel.purpleDiceResult = 2
        viewModel.checkGameState()
        XCTAssertEqual(viewModel.gameState, .end)
        XCTAssertEqual(viewModel.gameResult, .pinkWin)
        XCTAssertEqual(viewModel.titleText, LocalizableStrings.Result.pinkWin)
    }
    
    func test_CheckGameState_End_PurpleWins() {
        viewModel.pinkDicePlayed = true
        viewModel.purpleDicePlayed = true
        viewModel.pinkDiceResult = 2
        viewModel.purpleDiceResult = 6
        viewModel.checkGameState()
        XCTAssertEqual(viewModel.gameState, .end)
        XCTAssertEqual(viewModel.gameResult, .purpleWin)
        XCTAssertEqual(viewModel.titleText, LocalizableStrings.Result.purpleWin)
    }
    
    func test_CheckGameState_End_Tie() {
        viewModel.pinkDicePlayed = true
        viewModel.purpleDicePlayed = true
        viewModel.pinkDiceResult = 2
        viewModel.purpleDiceResult = 2
        viewModel.checkGameState()
        XCTAssertEqual(viewModel.gameState, .end)
        XCTAssertEqual(viewModel.gameResult, .tie)
        XCTAssertEqual(viewModel.titleText, LocalizableStrings.Result.tie)
    }
    
    func test_CalculateGameResult_PinkWins() {
        viewModel.pinkDiceResult = 6
        viewModel.purpleDiceResult = 2
        let result = viewModel.calculateGameResult()
        XCTAssertEqual(result, .pinkWin)
    }
    
    func test_CalculateGameResult_PurpleWins() {
        viewModel.pinkDiceResult = 1
        viewModel.purpleDiceResult = 5
        let result = viewModel.calculateGameResult()
        XCTAssertEqual(result, .purpleWin)
    }
    
    func test_CalculateGameResult_Tie() {
        viewModel.pinkDiceResult = 4
        viewModel.purpleDiceResult = 4
        let result = viewModel.calculateGameResult()
        XCTAssertEqual(result, .tie)
    }
    
    func test_GetImageName_Pink() {
        viewModel.pinkDiceResult = 3
        let imageName = viewModel.getImageName(type: .pink)
        XCTAssertEqual(imageName, "pink3")
    }
    
    func test_GetImageName_Purple() {
        viewModel.purpleDiceResult = 5
        let imageName = viewModel.getImageName(type: .purple)
        XCTAssertEqual(imageName, "purple5")
    }
    
    func test_AnimateDice_Pink() {
        let expectation = self.expectation(description: "Wait for timer")
        viewModel.animateDice(type: .pink) { _ in
            XCTAssertTrue(self.viewModel.pinkDicePlayed)
            XCTAssert(self.viewModel.pinkDiceResult >= 1 && self.viewModel.pinkDiceResult <= 6)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_AnimateDice_Purple() {
        let expectation = self.expectation(description: "Wait for timer")
        viewModel.animateDice(type: .purple) { _ in
            XCTAssertTrue(self.viewModel.purpleDicePlayed)
            XCTAssert(self.viewModel.purpleDiceResult >= 1 && self.viewModel.purpleDiceResult <= 6)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_GetGameSounds() {
         viewModel.getGameSounds()
         XCTAssertNotNil(viewModel.diceSound)
         XCTAssertNotNil(viewModel.winSound)
     }    
}
