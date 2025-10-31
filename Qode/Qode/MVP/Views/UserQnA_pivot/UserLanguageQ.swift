//
//  UserLanguageQ.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-10-25.
//

import SwiftUI


struct LanguageQView: View {
    var body: some View {
        ScrollView{
            VStack{
                LanguageHeaderView()
                Spacer()
                LanguageCardView()
                Spacer()
                LanguageButtonView()
            }
        }
    }
}

struct LanguageHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack{
                // vertical progress bars. Add here if more QnA pages are added!
                // Still do not know if width has to be manually stated. or is there a way that it evenly distributes the Views by itself?
                ProgressView(value: 1.0).frame(width: 100.0)
                Spacer()
                ProgressView(value: 1.0).frame(width: 100.0)
                Spacer()
                ProgressView(value: 0.0).frame(width: 100.0)
                }.padding()
            Text ("Select Your Language")
                .font(.title)
                .fontWeight(.light)
                .padding()
            Text ("Available in : ")
                .font(.title)
                .fontWeight(.light)
                .padding()
        }
        .padding()
    }
}


struct LanguageCardView: View {
    @State private var didTap1:Bool = false
    @State private var didTap2:Bool = false
    @State private var didTap3:Bool = false
    @State private var didTap4:Bool = false
    @State private var didTap5:Bool = false
    
    var body: some View {
        VStack(alignment: .center){
            Button(action: {
                didTap1.toggle()
            }, label: {
                LanguageCustomRowView(buttonTitle: "Python", isSelected: didTap1)
            })
            
            Button(action: {
                didTap2.toggle()
            }, label: {
                LanguageCustomRowView(buttonTitle: "Java",
                    isSelected: didTap2)
            })
            
            Button(action: {
                didTap3.toggle()
            }, label: {
                LanguageCustomRowView(buttonTitle: "Java Script" ,isSelected: didTap3)
            })
            
            Button(action: {
                didTap4.toggle()
            }, label: {
                LanguageCustomRowView(buttonTitle: "C" ,isSelected: didTap4)
            })
            
            Spacer()
        }.padding()
            
    }
}

struct LanguageCustomRowView: View {
    
    let buttonTitle: String
    let isSelected: Bool
    
    var body: some View {
        
        VStack {
            Text(buttonTitle).bold()
        }.frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding(.vertical, 25)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1)
                )
            )
            
    }
}


struct LanguageButtonView: View {
    var body: some View {
        HStack(spacing:100){
            Button("Back",action:
                    {
                print("hello")
            }).frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius:12)
                    .fill(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 12)
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
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1)
                ))
        }.padding()
        
            
    }
}

#Preview {
    LanguageQView()
}
