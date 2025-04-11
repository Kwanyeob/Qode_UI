//
//  Homeview.swift
//  feature_ky
//
//  Created by Kwan Yeob Jung on 2025-04-08.
//

import SwiftUI


struct Homeview: View {
    @State private var home = HomemModel.preview()
    @State private var selectedTab = 0
    @State private var showAddUser = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - only visible on home tab
            HeaderView()
                .opacity(selectedTab == 0 ? 1 : 0)
                .animation(.easeInOut, value: selectedTab)
            
            // Content based on selected tab
            ZStack {
                // Home View
                VStack(spacing: 0) {
                    // Add User Button
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddUser = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                    .background(Color(UIColor.systemGray6))
                    
                    List(home) { home in
                        HomeRow(home: home)
                    }
                }
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
            
            // Bottom Navigation Bar
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray)
                    .frame(height: 1)
                
                HStack(spacing: 0) {
                    Spacer()
                    Button(action: { selectedTab = 0 }) {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(selectedTab == 0 ? .blue : .gray)
                            Text("Home")
                                .foregroundColor(selectedTab == 0 ? .blue : .gray)
                        }
                    }
                    Spacer()
                    Divider()
                        .frame(height: 30)
                    Spacer()
                    Button(action: { selectedTab = 1 }) {
                        VStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(selectedTab == 1 ? .blue : .gray)
                            Text("Quiz")
                                .foregroundColor(selectedTab == 1 ? .blue : .gray)
                        }
                    }
                    Spacer()
                    Divider()
                        .frame(height: 30)
                    Spacer()
                    Button(action: { selectedTab = 2 }) {
                        VStack {
                            Image(systemName: "bubble.left.fill")
                                .foregroundColor(selectedTab == 2 ? .blue : .gray)
                            Text("Discuss")
                                .foregroundColor(selectedTab == 2 ? .blue : .gray)
                        }
                    }
                    Spacer()
                    Divider()
                        .frame(height: 30)
                    Spacer()
                    Button(action: { selectedTab = 3 }) {
                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(selectedTab == 3 ? .blue : .gray)
                            Text("My Stats")
                                .foregroundColor(selectedTab == 3 ? .blue : .gray)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
            }
        }
        .sheet(isPresented: $showAddUser) {
            AddUserView(isPresented: $showAddUser)
        }
    }
}

struct HomeRow: View {
    let home: HomemModel
    @State private var showUserDetail = false
    
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
                showUserDetail = true
            }) {
                Text(home.name)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Image(systemName: "paperplane.fill")
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showUserDetail) {
            UserDetailView(user: home)
        }
    }
}

struct HeaderView: View {
    @State private var showProfilePopup = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {
                    showProfilePopup = true
                }) {
                    Text("John Doe")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("You have 3 new streaks waiting 🔥")
                    .font(.subheadline)
                    .foregroundColor(.orange)
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

struct AddUserView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add User Form")
                    .font(.title)
                // Add your form content here
            }
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}

struct UserDetailView: View {
    let user: HomemModel
    
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
    Homeview()
}
