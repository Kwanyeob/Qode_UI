import Foundation

struct HomemModel: Identifiable {
    let id = UUID()
    let name: String
    let streakCount: Int
    let unreadStreaks: Int
    
    static func preview() -> [HomemModel] {
        [
            HomemModel(name: "John Doe", streakCount: 5, unreadStreaks: 2),
            HomemModel(name: "Alice Smith", streakCount: 3, unreadStreaks: 0),
            HomemModel(name: "Bob Johnson", streakCount: 7, unreadStreaks: 1),
            HomemModel(name: "Emma Wilson", streakCount: 2, unreadStreaks: 3),
            HomemModel(name: "Michael Brown", streakCount: 4, unreadStreaks: 0),
            HomemModel(name: "Sarah Davis", streakCount: 6, unreadStreaks: 1),
            HomemModel(name: "David Miller", streakCount: 1, unreadStreaks: 0),
            HomemModel(name: "Lisa Anderson", streakCount: 8, unreadStreaks: 2),
            HomemModel(name: "James Taylor", streakCount: 3, unreadStreaks: 0),
            HomemModel(name: "Emily White", streakCount: 5, unreadStreaks: 1),
            HomemModel(name: "Robert Martinez", streakCount: 4, unreadStreaks: 0),
            HomemModel(name: "Jennifer Lee", streakCount: 2, unreadStreaks: 0),
            HomemModel(name: "William Clark", streakCount: 7, unreadStreaks: 1),
            HomemModel(name: "Patricia Hall", streakCount: 6, unreadStreaks: 0),
            HomemModel(name: "Thomas Young", streakCount: 3, unreadStreaks: 2),
            HomemModel(name: "Mary Turner", streakCount: 5, unreadStreaks: 0),
            HomemModel(name: "Daniel King", streakCount: 4, unreadStreaks: 1),
            HomemModel(name: "Nancy Scott", streakCount: 2, unreadStreaks: 0)
        ]
    }
} 