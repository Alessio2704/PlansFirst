//
//  NetworkConnectionManager.swift
//  PlansNew
//
//  Created by Alessio Marcuzzi on 03/02/22.
//


import Foundation
import Network

class InternetConnectionManager: ObservableObject {
    
    @Published var isActive = false
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkQueue")
    
    init() {
        monitor.pathUpdateHandler = { path in
            
            DispatchQueue.main.async {
                self.isActive = (path.status == .satisfied)
            }
        }
        
        self.monitor.start(queue: self.queue)
    }
}

