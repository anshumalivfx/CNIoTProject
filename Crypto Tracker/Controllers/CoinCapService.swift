//
//  CoinCapService.swift
//  Crypto Tracker
//
//  Created by Anshumali Karna on 27/04/23.
//
import Combine
import Foundation
import Network

class CoinCapPriceService: NSObject {
    private let session = URLSession(configuration: .default)
    private var wsTask: URLSessionWebSocketTask?
    
    private let coinDictionarySubject = CurrentValueSubject<[String: Coin], Never>([:])
    private var coinDictionary: [String: Coin] { coinDictionarySubject.value }
    
    
    private var connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    
    private var isConnected: Bool { connectionStateSubject.value }
    
    
    func connect() {
        let coin = CoinType.allCases
            .map{
                $0.rawValue
            }
            .joined(separator: ",")
        
        let url = URL(string: "wss://ws.coincap.io/prices?assets=\(coin)")
        
        wsTask = session.webSocketTask(with: url!)
        wsTask?.delegate = self
        wsTask?.resume()
    }
    
    private func recieveMessage() {
        wsTask?.receive{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self.onRecieveData(data)
                    }
                case .data(let data):
                    self.onRecieveData(data)
                }
            case .failure(let error):
                print("Failed To Recieve Message \(error.localizedDescription)")
            }
            
        }
    }
    
    private func onRecieveData(_ data: Data) {
        guard let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String : String] else {
            return
        }
        
        var newDictionary = [String: Coin]()
        dictionary.forEach { (key, value) in
            let value = Double(value)
            
        }
    }
    
    deinit {
        coinDictionarySubject.send(completion: .finished)
        connectionStateSubject.send(completion: .finished)
        
    }
}

extension CoinCapPriceService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
    }
}
