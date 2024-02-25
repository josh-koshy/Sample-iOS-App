//
//  MainViewModel.swift
//  Crosp
//
//  Created by Joshua Koshy on 1/16/24.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import Firebase
import SwiftUI

class MainViewModel: ObservableObject {
    
    func formatDate(dateObject: Date) -> String {
        let formatter1 = DateFormatter()
        formatter1.locale = Locale(identifier: "en_US")
        formatter1.dateStyle = .long
        return formatter1.string(from: dateObject)
    }
    
}
