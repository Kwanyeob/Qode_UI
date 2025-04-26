//
//  QuizViewController.swift
//  Qode
//
//  Created by David Lee on 4/9/25.
//

/*
import UIKit

class QuizViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Quiz"
    }
}
*/

// Quiz tab 안에서 문제 상세 페이지로 push 한다면 이렇게 사용
/*
 let detailVC = QuizDetailViewController()
 navigationController?.pushViewController(detailVC, animated: true)
 */

import SwiftUI

struct QuizView: View {
    var body: some View {
        VStack {
            Text("Quiz")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .navigationTitle("Quiz")
        .background(Color.white)
    }
}

#Preview {
    NavigationView {
        QuizView()
    }
}
