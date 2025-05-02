//
//  RegisterView.swift
//  Qode
//
//  Created by David Lee on 4/12/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var presenter = RegisterPresenter()

    var body: some View {
        VStack(spacing: 20) {
            
            // ⬅️ Back 버튼
            if presenter.currentStep != .name {
                HStack {
                    Button(action: {
                        presenter.previousStep()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .transition(.move(edge: .leading))
            }

            Spacer()

            // 🔤 Step Title
            Text(presenter.currentStep.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // 📝 조건 안내 (비밀번호 단계만)
            if presenter.currentStep == .password {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password must include:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("• At least 6 characters")
                    Text("• 1 capital letter (A–Z)")
                    Text("• 1 special character (!@#$...)")
                }
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 🧾 입력 필드 (SecureField 또는 TextField)
            Group {
                if presenter.currentStep.isSecure {
                    SecureField(presenter.currentStep.placeholder, text: $presenter.inputText)
                } else {
                    TextField(presenter.currentStep.placeholder, text: $presenter.inputText)
                        .keyboardType(presenter.currentStep == .email ? .emailAddress : .default)
                }
            }
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .overlay(
                Group {
                    if presenter.currentStep == .email &&
                        !presenter.isValidEmail(presenter.inputText) &&
                        !presenter.inputText.isEmpty {
                        Text("Invalid email format.")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }

                    if presenter.currentStep == .password &&
                        !presenter.isValidPassword(presenter.inputText) &&
                        !presenter.inputText.isEmpty {
                        Text("Invalid password format.")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }
                },
                alignment: .bottomLeading
            )

            // ⏭️ Next or Sign Up 버튼
            Button(action: {
                presenter.nextStep()
            }) {
                Text(presenter.currentStep == .password ? "Sign Up" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(presenter.isInputValid ? Color(.darkGray) : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!presenter.isInputValid)

            Spacer()
        }
        .padding(.horizontal, 32)
        .alert(isPresented: .constant(presenter.alertMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(presenter.alertMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $presenter.isRegistered) {
            MainTabBarView()
        }
    }
}

#Preview {
    RegisterView()
}

