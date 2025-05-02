//
//  RegisterStep.swift
//  Qode
//
//  Created by David Lee on 4/12/25.
//

enum RegisterStep: Int, CaseIterable {
    case name, username, email, password

    var title: String {
        switch self {
        case .name: return "What's your name?"
        case .username: return "Choose a username"
        case .email: return "Enter your email"
        case .password: return "Create a password"
        }
    }

    var placeholder: String {
        switch self {
        case .name: return "Your name"
        case .username: return "e.g. sangmin123"
        case .email: return "email@example.com"
        case .password: return "Password"
        }
    }

    var isSecure: Bool {
        self == .password
    }
}
