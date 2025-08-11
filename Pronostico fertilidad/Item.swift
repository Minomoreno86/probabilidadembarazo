//
//  Item.swift
//  Pronostico fertilidad
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
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
