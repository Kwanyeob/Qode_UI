//
//  UserStatsPopOver.swift
//  Qode
//
//  Created by David Lee on 4/25/25.
//

import SwiftUI
import Charts

struct UserStatsPopover: View {
    let userName: String
    @Binding var isPresented: Bool
    @State private var selectedTab = 0
    
    // Sample data - replace with actual data from your model
    let easyQuestionsSolved = 15
    let mediumQuestionsSolved = 8
    let hardQuestionsSolved = 3
    let activeSince = "2023-01-15"
    let totalStreaksSent = 42
    
    // Sample heat map data - replace with actual data
    let heatMapData: [QuizActivity] = [
        QuizActivity(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 3),
        QuizActivity(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 5),
        QuizActivity(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 2),
        QuizActivity(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 0),
        QuizActivity(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 7),
        QuizActivity(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 4),
        QuizActivity(date: Date(), count: 6)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text("\(userName)'s Statistics")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
            .padding(.bottom, 5)
            
            // Donut Chart
            VStack(alignment: .leading) {
                Text("Questions Solved")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack {
                    // Donut Chart
                    ZStack {
                        Circle()
                            .trim(from: 0, to: CGFloat(easyQuestionsSolved) / CGFloat(totalQuestions))
                            .stroke(Color.green, lineWidth: 15)
                            .rotationEffect(.degrees(-90))
                        
                        Circle()
                            .trim(from: CGFloat(easyQuestionsSolved) / CGFloat(totalQuestions),
                                  to: CGFloat(easyQuestionsSolved + mediumQuestionsSolved) / CGFloat(totalQuestions))
                            .stroke(Color.orange, lineWidth: 15)
                            .rotationEffect(.degrees(-90))
                        
                        Circle()
                            .trim(from: CGFloat(easyQuestionsSolved + mediumQuestionsSolved) / CGFloat(totalQuestions),
                                  to: 1.0)
                            .stroke(Color.red, lineWidth: 15)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(totalQuestions)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Total")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 100, height: 100)
                    
                    // Legend
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                            Text("Easy: \(easyQuestionsSolved)")
                                .font(.caption)
                        }
                        
                        HStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 10, height: 10)
                            Text("Medium: \(mediumQuestionsSolved)")
                                .font(.caption)
                        }
                        
                        HStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                            Text("Hard: \(hardQuestionsSolved)")
                                .font(.caption)
                        }
                    }
                    .padding(.leading, 5)
                }
            }
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            
            // Activity Stats
            HStack(spacing: 15) {
                VStack(alignment: .leading) {
                    Text("Active Since")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(activeSince)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("Total Streaks")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("\(totalStreaksSent)")
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            
            // Heat Map
            VStack(alignment: .leading) {
                Text("Activity Heat Map")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
                    ForEach(heatMapData) { activity in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(heatMapColor(for: activity.count))
                            .frame(height: 20)
                            .overlay(
                                Text("\(activity.count)")
                                    .font(.system(size: 8))
                                    .foregroundColor(activity.count > 0 ? .white : .clear)
                            )
                    }
                }
                
                HStack {
                    Text("Less")
                        .font(.caption2)
                    Spacer()
                    Text("More")
                        .font(.caption2)
                }
                .padding(.top, 2)
            }
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
        }
        .padding(10)
        .frame(width: 220)
    }
    
    private var totalQuestions: Int {
        return easyQuestionsSolved + mediumQuestionsSolved + hardQuestionsSolved
    }
    
    private func heatMapColor(for count: Int) -> Color {
        switch count {
        case 0:
            return Color(UIColor.systemGray6)
        case 1...2:
            return Color.green.opacity(0.3)
        case 3...4:
            return Color.green.opacity(0.5)
        case 5...6:
            return Color.green.opacity(0.7)
        default:
            return Color.green
        }
    }
}

struct QuizActivity: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

#Preview {
    UserStatsPopover(userName: "John Doe", isPresented: .constant(true))
}
