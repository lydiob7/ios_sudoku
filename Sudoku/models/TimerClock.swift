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
        isRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
    }
    
    @objc func addTime() {
        timeElapsed += 1
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resume() {
        isRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
    }
    
    func reset() {
        timeElapsed = 0
    }
}

