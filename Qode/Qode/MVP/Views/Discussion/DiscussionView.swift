//
//  DiscussionViewController.swift
//  Qode
//
//  Created by David Lee on 4/9/25.
//
/*
import UIKit

class DiscussionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Discussions"
    }
}
*/
import SwiftUI

struct DiscussionView: View {
    var body: some View {
        VStack {
            Text("Discussions")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .navigationTitle("Discussions")
        .background(Color.white)
    }
}

#Preview {
    NavigationView {
        DiscussionView()
    }
}
