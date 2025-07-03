//
//  KeyboardDelay.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import Foundation

class KeyboardDelay {
    
    var clickCount: Int = 0
    var time: TimeInterval
    
    init(_ time: TimeInterval = 0.4) {
        self.time = time
    }
    
    func onType(onValid: @escaping () -> Void) {
        clickCount += 1
        let localCount = clickCount
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            Task {
                if (self.clickCount == localCount) {
                    onValid()
                }
            }
        }
    }
    
}
