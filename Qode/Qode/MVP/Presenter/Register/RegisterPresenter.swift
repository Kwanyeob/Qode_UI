//
//  RegisterPresenter.swift
//  Qode
//
//  Created by David Lee on 4/12/25.
//
import Foundation
import SwiftUI

class RegisterPresenter: NSObject, ObservableObject {
    @Published var currentStep: RegisterStep = .name
    @Published var inputText: String = ""
    @Published var isRegistered = false
    @Published var alertMessage: String?

    private var request = RegisterRequest()
    weak var view: RegisterViewProtocol?

    init(view: RegisterViewProtocol? = nil) {
        self.view = view
    }

    func previousStep() {
        if let previous = RegisterStep(rawValue: currentStep.rawValue - 1) {
            currentStep = previous
            switch currentStep {
            case .name: inputText = request.name
            case .username: inputText = request.username
            case .email: inputText = request.email
            case .password: inputText = request.password
            }
        }
    }

    func nextStep() {
        switch currentStep {
        case .name:
            request.name = inputText
        case .username:
            request.username = inputText
        case .email:
            request.email = inputText
        case .password:
            request.password = inputText
        }

        if currentStep == .password {
            submitRegistration()
        } else if let next = RegisterStep(rawValue: currentStep.rawValue + 1) {
            currentStep = next
            inputText = ""
        }
    }

    private func submitRegistration() {
        guard !request.name.isEmpty,
              isValidEmail(request.email),
              request.password.count >= 6 else {
            alertMessage = "Please fill in all fields correctly."
            return
        }

        // Register success simulation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isRegistered = true
        }
    }

    var isInputValid: Bool {
        switch currentStep {
        case .name:
            return !inputText.trimmingCharacters(in: .whitespaces).isEmpty
        case .username:
            return !inputText.trimmingCharacters(in: .whitespaces).isEmpty && inputText.count >= 3
        case .email:
            return isValidEmail(inputText)
        case .password:
            return isValidPassword(inputText)
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let pattern = #"^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$"#
        return password.range(of: pattern, options: .regularExpression) != nil
    }
}
