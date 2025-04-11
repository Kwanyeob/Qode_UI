//
//  Homemodel.swift
//  feature_ky
//
//  Created by Kwan Yeob Jung on 2025-04-08.
//

import Foundation
struct HomemModel: Identifiable{
    var name: String
    var sendIcon: Bool
    var isStreak: Bool
    let id = UUID()
    
    
    static func preview () -> [HomemModel]{
        return [HomemModel(name: "John Doe", sendIcon: true, isStreak: true),HomemModel(name: "Florence Zhang", sendIcon: true, isStreak:false)]
    }
    
}
