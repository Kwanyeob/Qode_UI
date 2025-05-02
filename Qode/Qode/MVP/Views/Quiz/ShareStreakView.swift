//
//  ShareStreakView.swift
//  Qode
//
//  Created by Kwan Yeob Jung on 2025-05-01.
//
import Foundation
import SwiftUI
struct ShareStreakSheet: View {
    @State private var selectedFriend: HomeModel? = nil
    let friends = HomeModel.preview()

    var body: some View {
        VStack(spacing: 20) {
            Text("Learn with a friend by sharing the streaks")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.top, 32)

            List(friends) { friend in
                Button(action: {
                    selectedFriend = friend
                }) {
                    HStack {
                        Text(friend.name)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedFriend?.id == friend.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(selectedFriend?.id == friend.id ? Color.blue.opacity(0.1) : Color.clear)
            }
            .listStyle(PlainListStyle())
            .frame(maxHeight: 300)

            Spacer()

            HStack(spacing: 20) {
                Button(action: {
                    // Skip action
                }) {
                    Text("Skip")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Send action
                }) {
                    Text("Send")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedFriend != nil ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(selectedFriend == nil)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .padding(.horizontal)
    }
}
