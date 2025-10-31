//
//  HomeMain.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-10-28.
//

import SwiftUI

enum subTitleType {
    case time
    case solved
    
}

struct HomeMain: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                HomeHeaderView()
                WeeklyStreakView()
                MiniStatView()
                UpNextView()
                WeeklyRecommendView()
            }.padding(.horizontal)
        // find out a better color. It is too gray. Make it more whiter.
        }.background(Color(.systemGray6))
        TabView{
            HomeMenuView(label:"Home", image:"house")
            HomeMenuView(label:"Roadmap", image:"map")
            HomeMenuView(label:"Stats", image:"align.vertical.bottom.fill")
            HomeMenuView(label:"Profile", image:"person.crop.circle")
        }.frame(height: 45)
    }
}


struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Text("Welcome!").bold().font(.title)
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
        }.padding()
    }
    
}

struct WeeklyStreakView: View{
    var body: some View{
        VStack{
            Text("Weekly Streak")
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack{
                CheckMarkAndDate(checked:true, inputDay:"Monday")
                Spacer()
                CheckMarkAndDate(checked:true, inputDay:"Tuseday")
                Spacer()
                CheckMarkAndDate(checked:true, inputDay:"Monday")
                Spacer()
                CheckMarkAndDate(checked:true, inputDay:"Wednesday")
                Spacer()
                CheckMarkAndDate(checked:true, inputDay:"Thursday")
                Spacer()
                CheckMarkAndDate(checked:false, inputDay:"Friday")
                Spacer()
                CheckMarkAndDate(checked:false, inputDay:"Saturday")
                Spacer()
                CheckMarkAndDate(checked:false, inputDay:"Sunday")
            }.padding(.horizontal, 8)
                .padding(.bottom, 8)
        }.padding()
        .background(
            Color.white
        )
    }
}

// check how we will take care the day in DB or anywhere and change accordingly (Monday? or Mon?)
struct CheckMarkAndDate: View {
    let checked: Bool
    let inputDay: String
    let day =
    ["Monday": "M",
     "Tuseday": "T",
     "Wednesday": "W",
     "Thursday" : "T",
     "Friday": "F",
     "Saturday" : "S",
     "Sunday" : "S"
    ]
    var body: some View {
        let dayValue = day[inputDay] ?? ""
        if(checked) {
            VStack{
                Image(systemName: "checkmark.circle.fill").foregroundColor(.blue).font(.system(size: 25))
                Spacer()
                Text(dayValue).foregroundColor(.blue)
            }
        }
        else {
            VStack{
                Image(systemName: "circle").foregroundColor(.gray).font(.system(size: 25))
                Spacer()
                Text(dayValue).foregroundColor(.gray)
            }
        }
        
    }
}

struct MiniStatView: View {
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                MiniStatCardView(unit: "DAYS", time: "24", numberSolved: "", title: "Log In Streak", subTitleType: .time)
                MiniStatCardView(unit: "WEEKS", time: "3", numberSolved: "", title: "Roadmap Progress", subTitleType: .time)
                MiniStatCardView(unit: "QUIZZES", time: "", numberSolved: "15", title: "# of CS Quizzes Solved", subTitleType: .solved)
                MiniStatCardView(unit: "solved", time: "", numberSolved: "21", title: "# of Algorithm Solved", subTitleType: .solved)
                MiniStatCardView(unit: "DAYS", time: "5", numberSolved: "", title: "Average Roadmap\rcompletion Time", subTitleType: .time)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

struct MiniStatCardView: View {
    let unit : String // hour? week? days?
    let time : String // If I pass 1 for time and hour for timeFrame, it will be 1 hour.
    let numberSolved : String
    let title : String // Log In Streak
    let subTitleType : subTitleType

    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 180, height: 150)
            
            VStack {
                Text(title)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.orange)
                var subTitle: String {
                    if subTitleType == .solved {
                        return numberSolved + " " + unit
                    } else {
                        return time + " " + unit
                    }
                }
                Spacer()
                Text(subTitle)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.blue)
            }.padding()
        }
        
    }
}

// think how to dynamically change the progress and the notification
struct UpNextView : View {
    var body: some View{
        VStack{
            Text ("UP NEXT")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(width: .infinity, height: 150)
                // add "Complete your js quiz
                // estimateed time 10 min
                // think about how this caption can be added dynamically.
            }
            Spacer()
            HStack{
                Text ("YOUR PROGRESS THIS WEEK").font(.caption).frame(alignment: .leading)
                Text ("50%").font(.caption).frame(alignment: .trailing)
            }
            ProgressView(value: 0.5).frame(maxWidth: .infinity)
            
        }
    }
}

struct WeeklyRecommendView : View {
    var body: some View {
        VStack {
            Text ("WEEKLY RECOMMENDED")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(width: .infinity, height: 150)
                // add "Complete your js quiz
                // estimateed time 10 min
                // think about how this caption can be added dynamically.
            }
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(width: .infinity, height: 150)
                // add "Complete your js quiz
                // estimateed time 10 min
                // think about how this caption can be added dynamically.
            }
        }
    }
}

struct HomeMenuView : View {
    let label : String
    let image : String
    var body: some View {
        Text("")
            .tabItem { Label(label, systemImage: image) }
    }
}

#Preview {
    HomeMain()
}
