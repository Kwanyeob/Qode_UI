//
//  UserCustomQ.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-10-25.
//


import SwiftUI


struct CustomQView: View {
    var body: some View {
        VStack{
            CustomHeaderView()
            Spacer()
            CustomCardView()
            Spacer()
            CustomButtonView()
        }
    }
}

struct CustomHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack{
                // vertical progress bars. Add here if more QnA pages are added!
                // Still do not know if width has to be manually stated. or is there a way that it evenly distributes the Views by itself?
                ProgressView(value: 1.0).frame(width: 100.0)
                Spacer()
                ProgressView(value: 1.0).frame(width: 100.0)
                Spacer()
                ProgressView(value: 1.0).frame(width: 100.0)
                }.padding()
            Text ("Customize your curriculum")
                .font(.title)
                .fontWeight(.light)
                .padding()
            Text ("Reorder the topics in the order you prefer : ")
                .font(.title2)
                .fontWeight(.light)
                .padding()
            Text ("Drag to reorder the topics ")
                .font(.footnote)
                .fontWeight(.light)
                .padding()
        }
        .padding()
    }
}

// later on, change the
struct CustomCardView: View {
    @State private var topics: [TopicItem] = [
        TopicItem(id: 1, title: "Data Structures", description: "Covering basic 15 data structures you must know"),
        TopicItem(id: 2, title: "Algorithms", description: "Coming Soon!"),
        TopicItem(id: 3, title: "System Design + Advanced Algorithms", description: "Coming Soon!")
//        TopicItem(id: 2, title: "Algorithms", description: "Covering the top 20 algorithms appears the most in the interviews"),
//        TopicItem(id: 3, title: "System Design + Advanced Algorithms", description: "Covering fundamental system design concepts and 15 advanced algorithms")
    ]
    
    var body: some View {
        List {
            ForEach(topics) { topic in
                Button(action: {
                }) {
                    CustomRowView(
                        buttonTitle: topic.title,
                        description: topic.description
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .listRowInsets(EdgeInsets())
            }
            .onMove(perform: moveItem)
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(.active))
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollDisabled(true)
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        topics.move(fromOffsets: source, toOffset: destination)
    }
}

// 새로운 데이터 모델
struct TopicItem: Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct CustomRowView: View {
    
    let buttonTitle: String
    let description: String
    
    var body: some View {
        HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(buttonTitle)
                        Text(description)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)
                .padding()  // 내부 padding
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                )
        }
    
}


struct CustomButtonView: View {
    var body: some View {
        HStack(spacing:100){
            Button("Back",action:
                    {
                print("hello")
            }).frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    ))
            
            Button("Next",action:
                    {
                print("hello")
            }).frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    ))
        }.padding()
        
            
    }
}

#Preview {
    CustomQView()
}
