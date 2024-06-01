//
//  TrackerModels.swift
//  Tracker
//
//  Created by Михаил  on 07.04.2024.
//

import Foundation
import UIKit

class Tracker{
    let id: UUID 
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
    var countOfDoneTrackers: Int = 0
    var isPinned: Bool = false 
    init(id: UUID, 
         name: String,
         color: UIColor,
         emoji: String,
         schedule: Schedule,
         isPinned: Bool,
         countOfDoneTrackers: Int ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.countOfDoneTrackers = countOfDoneTrackers
        self.isPinned = isPinned
    }
}

struct TrackerCategory{
    var title: String
    var trackers: [Tracker]
    
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
