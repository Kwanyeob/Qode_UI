//
//  HomeMain.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-10-28.
//

import SwiftUI

struct HomeMain: View {
    var body: some View {
        ScrollView{
            VStack{
                HomeHeaderView()
                Spacer()
                WeeklyStreakView()
                Spacer()
    //            MiniStatView()
    //            UpNextView()
    //            WeeklyRecommendView()
    //            HomeFooterView()
            }.padding()
        // find out a better color. It is too gray. Make it more whiter.
        }.background(Color(.systemGray6))
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
            }.padding()
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

struct MiniStatCardView: View {
    var body: some View {
        Text("Hello, World!")
    }
}



#Preview {
    HomeMain()
}
