//
//  CoinType.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//

import Foundation


enum CoinType: String, Identifiable, CaseIterable {
    case bitcoin
    case etherium
    case monero
    case litecoin
    case dogecoin
    
    var id: Self {self}
    var url: URL { URL(string: "https://coincap.io/assets/\(rawValue)")! }
    var description: String { rawValue.capitalized }
}
