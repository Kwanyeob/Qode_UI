//
//  UserRoleQ.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-10-25.
//

import SwiftUI


struct RoleQView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    RoleHeaderView()
                    Spacer()
                    RoleCardView()
                    Spacer()
                    RoleButtonView()
                }.navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct RoleHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack{
                // vertical progress bars. Add here if more QnA pages are added!
                // Still do not know if width has to be manually stated. or is there a way that it evenly distributes the Views by itself?
                ProgressView(value: 1.0).frame(width: 100.0)
                Spacer()
                ProgressView(value: 0.0).frame(width: 100.0)
                Spacer()
                ProgressView(value: 0.0).frame(width: 100.0)
                }.padding()
            Text ("Tell us about you")
                .font(.title)
                .fontWeight(.light)
                .padding()
            Text ("I am looking for: ")
                .font(.title)
                .fontWeight(.light)
                .padding()
        }
        .padding()
    }
}


struct RoleCardView: View {
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
                CustomRoleRowView(buttonTitle: "Begineer Opportunities", isSelected: didTap1, description: "0 years of experience without diaploma")
            })
            
            Button(action: {
                didTap2.toggle()
            }, label: {
                CustomRoleRowView(buttonTitle: "Internship",
                    isSelected: didTap2, description: "In School/0-1 year of experience")
            })
            
            Button(action: {
                didTap3.toggle()
            }, label: {
                CustomRoleRowView(buttonTitle: "Junior Roles" ,isSelected: didTap3, description: "0-2 years of experience with diaploma")
            })
            
            Button(action: {
                didTap4.toggle()
            }, label: {
                CustomRoleRowView(buttonTitle: "Mid Level Roles" ,isSelected: didTap4, description: "3-7 years of experience")
            })
            
            Button(action: {
                didTap5.toggle()
            }, label: {
                CustomRoleRowView(buttonTitle: "Senior Level Roles" ,isSelected: didTap5, description: "7+ years of experience")
            })
            
            Spacer()
        }.padding()
            
    }
}

struct CustomRoleRowView: View {
    
    let buttonTitle: String
    let isSelected: Bool
    let description: String
    
    var body: some View {
        
        VStack {
            Text(buttonTitle).bold()
            Spacer()
            Text(description)
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


struct RoleButtonView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack(spacing:100){
            Button(action: {
                dismiss()
            }) {
                Text("Back").frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 1)
                        ))
            }
            
            NavigationLink(destination: LanguageQView()) {
                Text("Next").frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 1)
                        ))
            }
        }.padding()
        
            
    }
}

#Preview {
    RoleQView()
}
