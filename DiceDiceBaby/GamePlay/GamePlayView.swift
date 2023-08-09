//
//  ContentView.swift
//  DiceDiceBaby
//
//  Created by glnygl on 30.07.2023.
//

import SwiftUI

struct GamePlayView: View {
    
    @StateObject var viewModel = GamePlayViewModel()
    
    var body: some View {
        VStack(spacing: 40.0) {
            Button {
                viewModel.diceSound.play()
                viewModel.roll(type: .purple)
            } label: {
                Image(viewModel.getImageName(type: .purple))
            }.allowsHitTesting(!viewModel.purpleDicePlayed)
            Text(viewModel.titleText)
                .font(.title)
                .fontWeight(.medium)
            Button {
                viewModel.diceSound.play()
                viewModel.roll(type: .pink)
            } label: {
                Image(viewModel.getImageName(type: .pink))
            }.allowsHitTesting(!viewModel.pinkDicePlayed)
        }
        .padding()
        .onAppear {
            viewModel.getGameSounds()
        }
        .allowsHitTesting(!viewModel.rollingDice)
    }
}

struct GamePlayView_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayView()
    }
}
