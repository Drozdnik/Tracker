//
//  TrackerModels.swift
//  Tracker
//
//  Created by Михаил  on 07.04.2024.
//

import Foundation
import UIKit
struct Schedule{
    
}


class Tracker{
    let id: UUID 
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Schedule) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}

struct TrackerCategory{
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}

struct TrackerRecord {
    let trackerId: UUID
    let date: Date

    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}
