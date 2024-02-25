//
//  HapticManagement.swift
//  Crosp
//
//  Created by Joshua Koshy on 6/27/22.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

/*
 Made the below functions using integer values and labels from:
 https://developer.apple.com/documentation/uikit/uiimpactfeedbackgenerator/feedbackstyle
 */

import Foundation
import SwiftUI

struct HapticManagement {
    
    private let lightHapticobj = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: 0)!)
    private let mediumHapticobj = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: 1)!)
    private let heavyHapticobj = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: 2)!)
    private let softHapticobj = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: 3)!)
    private let rigidHapticobj = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: 4)!)
    private let notifyHapticObj = UINotificationFeedbackGenerator()
    
    
    func lightHaptic() {
        lightHapticobj.prepare()
        lightHapticobj.impactOccurred()
    }
    
    func mediumHaptic() {
        mediumHapticobj.prepare()
        mediumHapticobj.impactOccurred()
    }
    
    func heavyHaptic() {
        heavyHapticobj.prepare()
        heavyHapticobj.impactOccurred()
    }
    
    func softHaptic() {
        softHapticobj.prepare()
        softHapticobj.impactOccurred()
    }
    
    func rigidHaptic() {
        rigidHapticobj.prepare()
        rigidHapticobj.impactOccurred()
    }
    
    func errorHaptic() {
        notifyHapticObj.prepare()
        notifyHapticObj.notificationOccurred(.error)
    }
    
    func successHaptic() {
        notifyHapticObj.prepare()
        notifyHapticObj.notificationOccurred(.success)
    }
    
    func warningHaptic() {
        notifyHapticObj.prepare()
        notifyHapticObj.notificationOccurred(.warning)
    }
}
