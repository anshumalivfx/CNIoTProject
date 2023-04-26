//
//  PopOverCoinView.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//

import SwiftUI

struct PopOverCoinView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text("BitCoin").font(.largeTitle)
                Text("$40000").font(.title.bold())
            }
            
            Divider()
            
            Button("Quit") {
                NSApp.terminate(self)
            }
        }
    }
}

struct PopOverCoinView_Previews: PreviewProvider {
    static var previews: some View {
        PopOverCoinView()
    }
}
