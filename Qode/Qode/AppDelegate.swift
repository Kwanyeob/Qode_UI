//
//  AppDelegate.swift
//  Qode
//
//  Created by David Lee on 4/8/25.
//
/*
import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // 기존 로그인 유지 여부 확인
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("🔓 로그아웃 상태입니다.")
            } else {
                print("✅ 로그인 상태 유지 중")
            }
        }

        // ❌ 절대 여기서 window 설정하지 마세요
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
*/

import SwiftUI
import GoogleSignIn

@main
struct QodeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("🔓 로그아웃 상태입니다.")
            } else {
                print("✅ 로그인 상태 유지 중")
            }
        }
        return true
    }

    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            var handled: Bool

            handled = GIDSignIn.sharedInstance.handle(url)
            if handled {
                return true
            }

            // Handle other custom URL types.

            // If not handled by this app, return false.
            return false
        }
}

