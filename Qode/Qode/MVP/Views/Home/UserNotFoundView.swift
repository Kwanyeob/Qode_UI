//
//  UserNotFoundView.swift
//  Qode
//
//  Created by David Lee on 4/25/25.
//

import SwiftUI

struct UserNotFoundView: View {
    @Binding var isPresented: Bool
    let username: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("User Not Found")
                .font(.headline)
            
            Text("We couldn't find a user with the username '\(username)'")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                isPresented = false
            }) {
                Text("OK")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 100)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(20)
        .frame(width: 250)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

#Preview {
    UserNotFoundView(isPresented: .constant(true), username: "testuser")
}
