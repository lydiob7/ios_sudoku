//
//  Timer.swift
//  Sudoku
//
//  Created by Tomi Scattini on 17/07/2024.
//

import Foundation

@Observable
class TimerClock {
    var timeElapsed: TimeInterval = 0
    var timer: Timer?
    var isRunning: Bool = false
    
    func formattedTime() -> String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func start() {
        guard !isRunning else { return }
        self.isRunning = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timeElapsed += 1
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stop() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resume() {
        start()
    }
    
    func reset() {
        stop()
        timeElapsed = 0
        start()
    }
}

