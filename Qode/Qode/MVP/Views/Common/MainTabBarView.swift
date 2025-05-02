//
//  MainTabBarController.swift
//  Qode
//
//  Created by David Lee on 4/9/25.
//
/*
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        // Home 탭
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        // Quiz 탭
        let quizVC = QuizViewController()
        let quizNav = UINavigationController(rootViewController: quizVC)
        quizNav.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)

        // Discussion 탭
        let discussionVC = DiscussionViewController()
        let discussionNav = UINavigationController(rootViewController: discussionVC)
        discussionNav.tabBarItem = UITabBarItem(title: "Discussion", image: UIImage(systemName: "bubble.right"), tag: 2)

        // Stats 탭
        let statsVC = StatisticsViewController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "chart.bar"), tag: 3)

        // 탭 구성
        self.viewControllers = [homeNav, quizNav, discussionNav, statsNav]

        // 스타일 설정
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
    }
}
*/
import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                QuizView()
                    .tabItem {
                        Label("Quiz", systemImage: "list.bullet.rectangle")
                    }

                DiscussionView()
                    .tabItem {
                        Label("Discussion", systemImage: "bubble.right")
                    }

                StatisticsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
            }
            .accentColor(.black)
        }
    }
}

#Preview {
    MainTabBarView()
}
