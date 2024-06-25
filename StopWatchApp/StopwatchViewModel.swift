//
//  StopwatchViewModel.swift
//  StopWatchApp
//
//  Created by Arpit iOS Dev. on 24/06/24.
//

import Foundation
import Combine

class StopwatchViewModel: ObservableObject {
    
    var stopwatchTimer: Timer?
    
    @Published var elapsedTime: TimeInterval = 0
    
    func startStop() {
        if let timer = stopwatchTimer {
            timer.invalidate()
            stopwatchTimer = nil
        } else {
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
                self?.elapsedTime += 0.01
            })
        }
    }
    
    func reset() {
        stopwatchTimer?.invalidate()
        stopwatchTimer = nil
        elapsedTime = 0
    }
    
    func formattedElapsedTime() -> String {
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int(elapsedTime * 100) % 100
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}
