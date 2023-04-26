//
//  PopOverCoinView.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//

import SwiftUI

struct PopOverCoinView: View {
    @ObservedObject var viewModel: PopOverCoinViewModel
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(viewModel.title).font(.largeTitle)
                Text(viewModel.subtitle).font(.title.bold())
            }
            
            Divider()
            
            Picker("Select Coin", selection: $viewModel.selectedCoinType){
                ForEach(viewModel.coinTypes) { type in
                    HStack {
                        Text(type.description).font(.headline)
                        Spacer()
                        Text(viewModel.valueText(for: type))
                            .frame(alignment: .trailing)
                            .font(.body)
                        
                        Link(destination: type.url) {
                            Image(systemName: "safari")
                        }
                    }
                    .tag(type)
                }
            }
            .pickerStyle(.radioGroup)
            .labelsHidden()
            
            Button("Quit") {
                NSApp.terminate(self)
            }
        }
        .onChange(of: viewModel.selectedCoinType){newValue in
            viewModel.updateView()
        }
        .onAppear {
            viewModel.subscribeToService()
        }
    }
}


