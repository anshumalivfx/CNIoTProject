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
    private var pingTryCount = 0
    
    let coinDictionarySubject = CurrentValueSubject<[String: Coin], Never>([:])
    var coinDictionary: [String: Coin] { coinDictionarySubject.value }
    
    
    var connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    
     var isConnected: Bool { connectionStateSubject.value }
    
    private let monitor = NWPathMonitor()
    
    
    
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
        self.recieveMessage()
        self.schedulePing()
    }
    
    func startMonitorNetworkConnectivity(){
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {
                return
            }
            
            if path.status == .satisfied, self.wsTask == nil {
                self.connect()
            }
            
            if path.status != .satisfied {
                self.clearConnection()
            }
            
            
            
        }
        
        monitor.start(queue: .main)
    }
    
    
    private func recieveMessage() {
        wsTask?.receive{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Recieve Text: \(text)")
                    if let data = text.data(using: .utf8) {
                        self.onRecieveData(data)
                    }
                case .data(let data):
                    print("\(data)")
                    self.onRecieveData(data)
                default: break
                }
                
                self.recieveMessage()
                
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
            newDictionary[key] = Coin(name: key.capitalized, value: value!)
        }
        
        let mergedDictionary = coinDictionary.merging(newDictionary) { $1 }
        
        coinDictionarySubject.send(mergedDictionary)
    }
    
    private func schedulePing() {
        let identifier = self.wsTask?.taskIdentifier ?? -1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self, let task = self.wsTask,
                  task.taskIdentifier == identifier
            else {
                return
            }
            
            if task.state == .running {
                self.pingTryCount += 1
                task.sendPing { [weak self] error in
                    if let error = error {
                        print("Ping Error: \(error)")
                    } else if self?.wsTask?.taskIdentifier == identifier {
                        self?.pingTryCount = 0
                    }
                    
                }
                self.schedulePing()
            } else {
                self.reconnect()
            }
        }
    }
    
    
    private func reconnect() {
        self.clearConnection()
        self.connect()
    }
    
    func clearConnection(){
        self.wsTask?.cancel()
        self.wsTask = nil
        
        self.connectionStateSubject.send(false)
    }
    
    deinit {
        coinDictionarySubject.send(completion: .finished)
        connectionStateSubject.send(completion: .finished)
        
    }
}

extension CoinCapPriceService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.connectionStateSubject.send(true)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.connectionStateSubject.send(false)
    }
}
