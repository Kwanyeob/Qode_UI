//
//  LoginViewController.swift
//  Qode
//
//  Created by David Lee on 4/8/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var presenter = LoginPresenter()
    @State private var showForgotSheet = false
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer() // 상단 여백
                
                VStack(spacing: 8) {
                    Image("login_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(.gray)
                }
            
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Enter your username and password\nto login")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                TextField("Username", text: $presenter.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $presenter.password)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Spacer()
                    Button("Forgot Password?") {
                        showForgotSheet = true
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .sheet(isPresented: $showForgotSheet) {
                        ForgotPasswordSheet()
                    }
                }
                
                Button(action: {
                    presenter.loginWithEmail()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.blue))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Text("Or login in with")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    // Google 버튼
                    Button(action: presenter.loginWithGoogle) {
                        HStack(spacing: 8) {
                            Image("GoogleLogo")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                            Text("Google")
                                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(Color(.darkGray))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }
                    
                    // Apple 버튼
                    Button(action: {
                        presenter.loginWithAppleManually()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "applelogo")
                                .font(.system(size: 24))
                                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
                            Text(" Apple")
                                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.darkGray))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.footnote)
                    
                    Button(action: {
                        showRegister = true
                    }) {
                        Text("Register")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.darkGray))
                    }
                }
                .navigationDestination(isPresented: $showRegister) {
                    RegisterPageView()
                }
                
                Text("Need help? Visit our ")
                    .font(.caption2)
                    .foregroundColor(.gray)
                + Text("help center")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .alert(isPresented: .constant(presenter.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(presenter.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $presenter.isLoggedIn) {
                MainTabBarView()
            }
        }
    }
}

#Preview {
    LoginView()
}
