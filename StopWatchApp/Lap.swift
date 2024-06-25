//
//  Lap.swift
//  StopWatchApp
//
//  Created by Arpit iOS Dev. on 24/06/24.
//

import Foundation

class Lap: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    let startTime: TimeInterval
    
    init(startTime: TimeInterval) {
        self.startTime = startTime
    }
    
    func formattedElapsedTime() -> String {
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int(elapsedTime * 100) % 100
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}
