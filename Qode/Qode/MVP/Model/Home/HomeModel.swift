//
//  HomeModel.swift
//  Qode
//
//  Created by David Lee on 4/25/25.
//

import Foundation

struct HomeModel: Identifiable {
    let id = UUID()
    let name: String
    let streakCount: Int
    let unreadStreaks: Int
    let hasReplied: Bool
    
    static func preview() -> [HomeModel] {
        [
            HomeModel(name: "John Doe", streakCount: 5, unreadStreaks: 2, hasReplied: false),
            HomeModel(name: "Alice Smith", streakCount: 3, unreadStreaks: 0, hasReplied: true),
            HomeModel(name: "Bob Johnson", streakCount: 7, unreadStreaks: 1, hasReplied: false),
            HomeModel(name: "Emma Wilson", streakCount: 2, unreadStreaks: 3, hasReplied: true),
            HomeModel(name: "Michael Brown", streakCount: 4, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "Sarah Davis", streakCount: 6, unreadStreaks: 1, hasReplied: false),
            HomeModel(name: "David Miller", streakCount: 1, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "Lisa Anderson", streakCount: 8, unreadStreaks: 2, hasReplied: false),
            HomeModel(name: "James Taylor", streakCount: 3, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "Emily White", streakCount: 5, unreadStreaks: 1, hasReplied: false),
            HomeModel(name: "Robert Martinez", streakCount: 4, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "Jennifer Lee", streakCount: 2, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "William Clark", streakCount: 7, unreadStreaks: 1, hasReplied: false),
            HomeModel(name: "Patricia Hall", streakCount: 6, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "Thomas Young", streakCount: 3, unreadStreaks: 2, hasReplied: false),
            HomeModel(name: "Mary Turner", streakCount: 5, unreadStreaks: 0, hasReplied: false),
            HomeModel(name: "Daniel King", streakCount: 4, unreadStreaks: 1, hasReplied: false),
            HomeModel(name: "Nancy Scott", streakCount: 2, unreadStreaks: 0, hasReplied: false)
        ]
    }
}
