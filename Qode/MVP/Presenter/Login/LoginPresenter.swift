//
//  LoginPresenter.swift
//  Qode
//
//  Created by David Lee on 4/10/25.
//
/*
import UIKit
import AuthenticationServices

class LoginPresenter {
    weak var view: LoginViewProtocol?
    let authService: AuthService

    init(view: LoginViewProtocol, authService: AuthService) {
        self.view = view
        self.authService = authService
    }

    func loginWithEmail(username: String, password: String) {
        let request = LoginRequest(username: username, password: password)
        authService.loginWithEmail(with: request) { [weak self] success, error in
            if success {
                self?.view?.goToHomeScreen()
            } else {
                self?.view?.showError(error ?? "Unknown error")
            }
        }
    }

    func loginWithGoogle(presentingVC: UIViewController) {
        authService.loginWithGoogle(presentingView: presentingVC) { [weak self] success, error in
            if success {
                self?.view?.goToHomeScreen()
            } else {
                self?.view?.showError(error ?? "Google login failed")
            }
        }
    }

    func loginWithApple(presentationProvider: ASAuthorizationControllerPresentationContextProviding, delegate: ASAuthorizationControllerDelegate) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        authService.loginWithApple(request: request, delegate: delegate, presentationContextProvider: presentationProvider)
    }
}
*/

import SwiftUI
import GoogleSignIn
import AuthenticationServices

class LoginPresenter: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @Published var username: String = "" // User Input Username
    @Published var password: String = "" // User Input Password
    @Published var isLoggedIn = false
    @Published var userEmail: String?
    @Published var userName: String? // System Output Username
    @Published var profileImageURL: URL?
    @Published var errorMessage: String?

    private let authService = AuthService()

    // MARK: - 이메일 로그인
    func loginWithEmail() {
        let request = LoginRequest(username: username, password: password)
        authService.loginWithEmail(with: request) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isLoggedIn = true
                } else {
                    self?.errorMessage = error ?? "Unknown error"
                }
            }
        }
    }

    // MARK: - Google 로그인
    func loginWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "Could not find root view controller"
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let signInResult = signInResult else {
                self.errorMessage = "Sign in failed"
                return
            }
            
            let user = signInResult.user
            
            // 사용자 정보 저장
            self.userEmail = user.profile?.email
            self.userName = user.profile?.name
            self.profileImageURL = user.profile?.imageURL(withDimension: 320)
            self.isLoggedIn = true
        }
    }
    /*
    func loginWithApple(result: Result<ASAuthorization, Error>) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
    }
    */

    // MARK: - Apple 로그인
    func loginWithAppleManually() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    // MARK: - Apple 로그인 Delegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.isLoggedIn = true
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = error.localizedDescription
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    // MARK: - 입력 유효성 검사 (옵션)
    var isInputValid: Bool {
        return !username.trimmingCharacters(in: .whitespaces).isEmpty &&
               !password.isEmpty
    }
}
