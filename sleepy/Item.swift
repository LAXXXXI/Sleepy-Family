//
//  Item.swift
//  sleepy
//
//  Created by Arthur Lai on 2026/1/21.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
