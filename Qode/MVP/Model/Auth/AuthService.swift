//
//  AuthService.swift
//  Qode
//
//  Created by David Lee on 4/10/25.
//
/*
import UIKit
import GoogleSignIn
import AuthenticationServices

class AuthService {
    func loginWithEmail(with request: LoginRequest, completion: @escaping (Bool, String?) -> Void) {
        if request.username == "test" && request.password == "1234" {
            completion(true, nil)
        } else {
            completion(false, "Invalid credentials")
        }
    }

    func loginWithGoogle(presentingView: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingView) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    func loginWithApple(request: ASAuthorizationAppleIDRequest, delegate: ASAuthorizationControllerDelegate, presentationContextProvider: ASAuthorizationControllerPresentationContextProviding) {
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = delegate
        controller.presentationContextProvider = presentationContextProvider
        controller.performRequests()
    }
}
*/

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

class AuthService {
    func loginWithEmail(with request: LoginRequest, completion: @escaping (Bool, String?) -> Void) {
        // Simulate async API login
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            if request.username == "test" && request.password == "1234" {
                completion(true, nil)
            } else {
                completion(false, "Invalid username or password")
            }
        }
    }

    func loginWithGoogle(presentingViewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        guard
            let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String
        else {
            completion(false, "Google Client ID not found in Info.plist")
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            guard let result = signInResult else {
                completion(false, "Google Sign-In failed.")
                return
            }

            print("Google 로그인 성공: \(result.user.profile?.email ?? "unknown")")
            completion(true, nil)
        }
    }

    func loginWithApple(request: ASAuthorizationAppleIDRequest, delegate: ASAuthorizationControllerDelegate, presentationContextProvider: ASAuthorizationControllerPresentationContextProviding) {
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = delegate
        controller.presentationContextProvider = presentationContextProvider
        controller.performRequests()
    }
}
