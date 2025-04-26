import SwiftUI

struct LeetCodeHeatmapView: View {
    let calendarData: [Date: Int]
    let totalSubmissions: Int
    let totalActiveDays: Int
    let maxStreak: Int
    let quarterRange: ClosedRange<Date>

    private let calendar = Calendar.current

    private func color(for count: Int) -> Color {
        switch count {
        case 0: return Color.gray.opacity(0.1)
        case 1...2: return Color.green.opacity(0.3)
        case 3...5: return Color.green.opacity(0.5)
        case 6...10: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }

    private var monthToDates: [(month: String, dates: [Date])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        let allDates = calendar.generateDates(for: quarterRange)
        let grouped = Dictionary(grouping: allDates, by: { formatter.string(from: $0) })

        let sortedKeys = allDates
            .map { formatter.string(from: $0) }
            .uniqued()

        return sortedKeys.map { key in (key, grouped[key] ?? []) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(totalSubmissions) submissions in the past one year")
                .font(.subheadline)
                .bold()
            Text("Total active days: \(totalActiveDays)  Max streak: \(maxStreak)")
                .font(.caption)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 16) {
                ForEach(monthToDates, id: \.month) { (month, dates) in
                    VStack(alignment: .center, spacing: 4) {
                        Text(month)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        let padded = dates + Array(repeating: Date.distantPast, count: max(0, 35 - dates.count))

                        LazyVGrid(columns: Array(repeating: GridItem(.fixed(6), spacing: 4), count: 5), spacing: 4) {
                            ForEach(Array(padded.enumerated()), id: \.offset) { index, date in
                                let count = calendarData[date.startOfDay] ?? 0
                                color(for: date == Date.distantPast ? 0 : count)
                                    .frame(width: 6, height: 6)
                                    .cornerRadius(1)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

extension Calendar {
    func generateDates(for range: ClosedRange<Date>) -> [Date] {
        var dates: [Date] = []
        var date = range.lowerBound
        while date <= range.upperBound {
            dates.append(date)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }
        return dates
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
