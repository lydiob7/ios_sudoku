// Copyright (C) 2024 Tomás Scattini
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
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

