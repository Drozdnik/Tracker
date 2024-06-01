//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Михаил  on 04.04.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let vc = TrackerViewController()
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
        
    }
    
}
