//
//  MenuBarCoinView.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//

import SwiftUI

struct MenuBarCoinView: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "circle.fill")
                .foregroundColor(.green)
            
            VStack(alignment: .trailing, spacing: -2) {
                Text("Bitcoin")
                Text("$40000")
            }
            .font(.caption)
        }
    }
}

struct MenuBarCoinView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarCoinView()
    }
}
