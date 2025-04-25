//
//  ForgotPasswordSheet.swift
//  Qode
//
//  Created by David Lee on 4/12/25.
//

import SwiftUI

struct ForgotPasswordSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Reset Your Password")
                    .font(.title3)
                    .fontWeight(.semibold)

                TextField("Enter your email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                Button("Send Reset Link") {
                    // 실제로는 이메일 유효성 체크 + API 호출 로직
                    if isValidEmail(email) {
                        showAlert = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.darkGray))
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Reset link sent!", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Please check your email inbox.")
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
