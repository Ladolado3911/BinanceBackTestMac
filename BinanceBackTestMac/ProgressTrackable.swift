//
//  ProgressTracker.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 3/19/24.
//

import Foundation

protocol ProgressTrackable {
    
    associatedtype TrackType
    
    var requiredTaskCount: Int { get set }
    var completedTaskCount: Int { get set }
    
    var statusPercentageDouble: Double { get }
    var statusPercentageString: String { get }
    
    func incrementCompletedTaskCount()
    func incrementRequiredTaskCount()
    func determineRequiredTaskCount(inputArray: [TrackType])
}


