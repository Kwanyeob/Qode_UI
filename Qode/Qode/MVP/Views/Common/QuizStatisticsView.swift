import SwiftUI

struct QuizStatisticsView: View {
    @ObservedObject var presenter: StatisticsPresenter

    var body: some View {
        VStack(spacing: 16) {
            // Quiz Chart
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Quiz")
                        .font(.headline)
                    Spacer()
                    Text("Weekly")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }

                QuizLineChartView(scores: presenter.quizWeeklyScores)
                    .frame(height: 200)
                    .padding(.top, 4)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            // Quiz Stats Grid
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    QuizStatCard(title: "quizzes solved", value: "\(presenter.quizSolvedCount)", icon: "doc.plaintext")
                    QuizStatCard(title: "longest streak", value: "\(presenter.quizLongestStreak)", icon: "flame")
                }
                HStack(spacing: 12) {
                    QuizStatCard(title: "accuracy rate", value: String(format: "%.0f%%", presenter.quizAccuracyRate * 100), icon: "clock")
                    QuizStatCard(title: "rank", value: "Top \(presenter.quizRankTopPercent)%", icon: "chart.bar")
                }
            }
            .padding(.horizontal)
        }
    }
}

struct QuizStatCard: View {
    var title: String
    var value: String
    var icon: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(maxWidth: .infinity)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuizLineChartView: View {
    let scores: [String: Int]
    @State private var hoveredIndex: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            let maxScore = max(scores.values.max() ?? 100, 100)
            let width = geometry.size.width
            let height = geometry.size.height - 24
            let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

            let points = days.enumerated().map { index, day in
                let x = width * CGFloat(index) / CGFloat(days.count - 1)
                let y = height - CGFloat(scores[day] ?? 0) / CGFloat(maxScore) * height
                return CGPoint(x: x, y: max(0, min(y, height)))
            }

            ZStack {
                // Grid lines and Y labels
                ForEach(0..<6) { i in
                    let y = height * CGFloat(i) / 5
                    let label = 100 - (i * 20)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)

                    Text("\(label)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .position(x: 20, y: y)
                }

                // Area background darker
                Path { path in
                    path.move(to: CGPoint(x: points.first?.x ?? 0, y: height))
                    path.addLines(points)
                    path.addLine(to: CGPoint(x: points.last?.x ?? 0, y: height))
                    path.closeSubpath()
                }
                .fill(Color.gray.opacity(0.25))

                // Smooth line
                Path { path in
                    guard points.count > 1 else { return }
                    path.move(to: points[0])
                    for i in 1..<points.count {
                        let prev = points[i - 1]
                        let current = points[i]
                        let mid = CGPoint(
                            x: (prev.x + current.x) / 2,
                            y: (prev.y + current.y) / 2
                        )
                        path.addQuadCurve(to: mid, control: prev)
                        path.addQuadCurve(to: current, control: mid)
                    }
                }
                .stroke(Color.black, lineWidth: 2)

                // Dots with hover
                ForEach(0..<points.count, id: \ .self) { i in
                    let point = points[i]
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .position(point)
                        .onHover { hovering in
                            hoveredIndex = hovering ? i : nil
                        }

                    if hoveredIndex == i {
                        Text("\(scores[days[i]] ?? 0)")
                            .font(.caption)
                            .padding(6)
                            .background(Color.white)
                            .cornerRadius(6)
                            .shadow(radius: 2)
                            .position(x: point.x, y: point.y - 30)
                    }
                }

                // Day labels
                ForEach(0..<days.count, id: \ .self) { i in
                    let x = width * CGFloat(i) / CGFloat(days.count - 1)
                    Text(days[i])
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .position(x: x, y: height + 16)
                }
            }
        }
        .frame(height: 220)
    }
}
