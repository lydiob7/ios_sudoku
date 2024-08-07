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
        self.isRunning = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
    }
    
    @objc func addTime() {
        self.timeElapsed += 1
    }
    
    func stop() {
        self.isRunning = false
        self.timer?.invalidate()
    }
    
    func resume() {
        self.isRunning = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
    }
    
    func reset() {
        self.stop()
        self.timeElapsed = 0
        self.resume()
    }
}

