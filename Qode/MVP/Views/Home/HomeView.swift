//
//  HomeViewController.swift
//  Qode
//
//  Created by David Lee on 4/8/25.
//
/*
import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
    }
}
*/
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .navigationTitle("Home")
        .background(Color.white)
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
