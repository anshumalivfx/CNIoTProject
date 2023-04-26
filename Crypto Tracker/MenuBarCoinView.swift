//
//  MenuBarCoinView.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//

import SwiftUI

struct MenuBarCoinView: View {
    @ObservedObject var viewModel: MenuBarCoinViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
            
            VStack(alignment: .trailing, spacing: -2) {
                Text(viewModel.name)
                Text(viewModel.value)
            }
            .font(.caption)
        }.onAppear {
            viewModel.subscribeToService()
        }
    }
}


