//
//  Homeview.swift
//  feature_ky
//
//  Created by Kwan Yeob Jung on 2025-04-08.
//

import SwiftUI

struct HomeView: View {
    @State private var home = HomeModel.preview()
    @State private var selectedTab = 0
    @State private var showAddUser = false
    @State private var newUsername = ""
    @State private var showUserNotFound = false
    @State private var showInviteSent = false
    
    var totalUnreadStreaks: Int {
        home.reduce(0) { $0 + $1.unreadStreaks }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header - only visible on home tab
                HeaderView(totalUnreadStreaks: totalUnreadStreaks)
                    .opacity(selectedTab == 0 ? 1 : 0)
                    .animation(.easeInOut, value: selectedTab)
                
                // Content based on selected tab
                ZStack {
                    // Home View
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            TextField("Search or add user by username", text: $newUsername, onCommit: {
                                if !newUsername.isEmpty {
                                    // Simulate user check - replace with actual API call
                                    if newUsername == "existinguser" {
                                        showInviteSent = true
                                    } else {
                                        showUserNotFound = true
                                    }
                                    newUsername = ""
                                }
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 10)
                            .padding(.trailing, 8)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .padding(.top, 12)
                        
                        // List in separate stack
                        VStack {
                            List(home) { home in
                                HomeRow(home: home)
                            }
                            .listStyle(PlainListStyle())
                        }
                        .padding(.top, 8)  // Add spacing between button and list
                        .background(Color(UIColor.systemGray6))
                    }
                    .background(Color(UIColor.systemGray6))
                    .opacity(selectedTab == 0 ? 1 : 0)
                    
                    // Quiz View
                    QuizView()
                        .opacity(selectedTab == 1 ? 1 : 0)
                    
                    // Discuss View
                    DiscussView()
                        .opacity(selectedTab == 2 ? 1 : 0)
                    
                    // Stats View
                    StatsView()
                        .opacity(selectedTab == 3 ? 1 : 0)
                }
                .animation(.easeInOut, value: selectedTab)
            }
            .sheet(isPresented: $showAddUser) {
                NavigationView {
                    VStack(spacing: 20) {
                        TextField("Enter username", text: $newUsername)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            // Here you would typically check if the user exists
                            // For now, we'll simulate the check
                            if newUsername.isEmpty {
                                return
                            }
                            
                            // Simulate user check - replace with actual API call
                            if newUsername == "existinguser" {
                                showInviteSent = true
                            } else {
                                showUserNotFound = true
                            }
                            showAddUser = false
                        }) {
                            Text("Add")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .disabled(newUsername.isEmpty)
                        
                        Spacer()
                    }
                    .navigationTitle("Add User")
                    .navigationBarItems(trailing: Button("Cancel") {
                        showAddUser = false
                    })
                }
            }
            .alert("Invite Sent", isPresented: $showInviteSent) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("An invite has been sent to \(newUsername)")
            }
            .sheet(isPresented: $showUserNotFound) {
                UserNotFoundView(isPresented: $showUserNotFound, username: newUsername)
            }
        }
    }
}

struct HomeRow: View {
    let home: HomeModel
    @State private var showUserDetail = false
    @State private var showStatsPopover = false
    
    var body: some View {
        HStack {
            Button(action: {
                showUserDetail = true
            }) {
                Image(systemName: "person.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.blue)
            }
            
            Button(action: {
                showStatsPopover = true
            }) {
                Text(home.name)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .popover(isPresented: $showStatsPopover) {
                UserStatsPopover(userName: home.name, isPresented: $showStatsPopover)
            }
            
            Spacer()
            
            ZStack(alignment: .topTrailing) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(home.hasReplied ? .gray : .blue)
                
                if home.unreadStreaks > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 22, height: 22)
                        Text("\(home.unreadStreaks)")
                            .foregroundColor(.white)
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    .offset(x: 8, y: -8)
                }
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showUserDetail) {
            UserDetailView(user: home)
        }
    }
}

struct HeaderView: View {
    @State private var showProfilePopup = false
    let totalUnreadStreaks: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {
                    showProfilePopup = true
                }) {
                    Text("Hello Kwanyeob")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                if totalUnreadStreaks > 0 {
                    Text("\(totalUnreadStreaks) new streaks waiting 🔥")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .overlay(
            Group {
                if showProfilePopup {
                    ProfilePopupView(isPresented: $showProfilePopup)
                }
            }
        )
    }
}

struct ProfilePopupView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button("Close") {
                    isPresented = false
                }
                .foregroundColor(.blue)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding()
        }
    }
}

struct UserDetailView: View {
    let user: HomeModel
    
    var body: some View {
        Text("User Detail View for \(user.name)")
    }
}

struct DiscussView: View {
    var body: some View {
        Text("Discuss View")
    }
}

struct StatsView: View {
    var body: some View {
        Text("Stats View")
    }
}

#Preview {
    HomeView()
}
