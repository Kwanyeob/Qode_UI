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

//
//  QuizView.swift
//  feature_ky
//
//  Created by Kwan Yeob Jung on 2025-04-11.
//

import Foundation

import SwiftUI

struct QuizView: View {
    @State private var quizState: QuizState = .start
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: Set<String> = []
    @State private var fillInBlankAnswer = ""
    @State private var questions: [QuizQuestion] = []
    @State private var userAnswers: [Int: Any] = [:]
    @State private var showResults = false
    @State private var showShareStreak = false
    @State private var navigateToShareStreak = false
    
    var body: some View {
        NavigationView {
            ZStack {
                switch quizState {
                case .start:
                    StartView(startQuiz: startQuiz)
                case .question:
                    if showResults {
                        ResultsView(
                            questions: questions,
                            userAnswers: userAnswers,
                            onShare: { navigateToShareStreak = true }
                        )
                    } else {
                        QuestionView(
                            question: questions[currentQuestionIndex],
                            selectedAnswers: $selectedAnswers,
                            fillInBlankAnswer: $fillInBlankAnswer,
                            onNext: nextQuestion,
                            onBack: previousQuestion,
                            onSubmit: submitQuiz,
                            isLastQuestion: currentQuestionIndex == questions.count - 1
                        )
                    }
                }
                NavigationLink(
                    destination: ShareStreakSheet(),
                    isActive: $navigateToShareStreak
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .onAppear {
            generateQuestions()
        }
    }
    
    private func startQuiz() {
        quizState = .question
        userAnswers.removeAll()
    }
    
    private func nextQuestion() {
        saveCurrentAnswer()
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswers.removeAll()
            fillInBlankAnswer = ""
        }
    }
    
    private func previousQuestion() {
        saveCurrentAnswer()
        
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            selectedAnswers.removeAll()
            fillInBlankAnswer = ""
        }
    }
    
    private func saveCurrentAnswer() {
        let question = questions[currentQuestionIndex]
        
        switch question.type {
        case .multipleChoice, .trueFalse:
            userAnswers[currentQuestionIndex] = selectedAnswers
        case .fillInBlank:
            userAnswers[currentQuestionIndex] = fillInBlankAnswer
        }
    }
    
    private func submitQuiz() {
        saveCurrentAnswer()
        showResults = true
    }
    
    private func restartQuiz() {
        quizState = .start
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        fillInBlankAnswer = ""
        userAnswers.removeAll()
        showResults = false
        generateQuestions()
    }
    
    private func generateQuestions() {
        // Sample questions - you can replace these with your actual questions
        questions = [
            QuizQuestion(
                type: .multipleChoice,
                question: "Which of the following are programming languages?",
                options: ["Python", "Java", "HTML", "CSS", "JavaScript"],
                correctAnswers: ["Python", "Java", "JavaScript"],
                explanation: "Python, Java, and JavaScript are programming languages. HTML and CSS are markup languages used for web development."
            ),
            QuizQuestion(
                type: .trueFalse,
                question: "Swift is a programming language developed by Apple.",
                correctAnswer: true,
                explanation: "Swift was introduced by Apple in 2014 as a replacement for Objective-C."
            ),
            QuizQuestion(
                type: .fillInBlank,
                question: "The process of finding and fixing errors in code is called _____.",
                correctAnswer: "debugging",
                explanation: "Debugging is the process of identifying and removing errors from software code."
            )
        ].shuffled()
    }
}

enum QuizState {
    case start
    case question
}

struct QuizQuestion {
    enum QuestionType {
        case multipleChoice
        case trueFalse
        case fillInBlank
    }
    
    let type: QuestionType
    let question: String
    var options: [String]?
    var correctAnswers: Set<String>?
    var correctAnswer: Any?
    var explanation: String?
    
    init(type: QuestionType, question: String, options: [String]? = nil, correctAnswers: Set<String>? = nil, correctAnswer: Any? = nil, explanation: String? = nil) {
        self.type = type
        self.question = question
        self.options = options
        self.correctAnswers = correctAnswers
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
    
    func isCorrect(userAnswer: Any) -> Bool {
        switch type {
        case .multipleChoice:
            if let userAnswers = userAnswer as? Set<String>, let correctAnswers = correctAnswers {
                return userAnswers == correctAnswers
            }
            return false
        case .trueFalse:
            if let userAnswer = userAnswer as? Set<String>, let correctAnswer = correctAnswer as? Bool {
                let userBool = userAnswer.contains("True")
                return userBool == correctAnswer
            }
            return false
        case .fillInBlank:
            if let userAnswer = userAnswer as? String, let correctAnswer = correctAnswer as? String {
                return userAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ==
                       correctAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return false
        }
    }
    
    func formatUserAnswer(_ userAnswer: Any) -> String {
        switch type {
        case .multipleChoice:
            if let answers = userAnswer as? Set<String> {
                return answers.joined(separator: ", ")
            }
            return "No answer"
        case .trueFalse:
            if let answers = userAnswer as? Set<String> {
                return answers.first ?? "No answer"
            }
            return "No answer"
        case .fillInBlank:
            if let answer = userAnswer as? String {
                return answer
            }
            return "No answer"
        }
    }
    
    func formatCorrectAnswer() -> String {
        switch type {
        case .multipleChoice:
            if let answers = correctAnswers {
                return answers.joined(separator: ", ")
            }
            return "Unknown"
        case .trueFalse:
            if let answer = correctAnswer as? Bool {
                return answer ? "True" : "False"
            }
            return "Unknown"
        case .fillInBlank:
            if let answer = correctAnswer as? String {
                return answer
            }
            return "Unknown"
        }
    }
}

struct StartView: View {
    let startQuiz: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .onAppear {
                    isAnimating = true
                }
            
            Button(action: startQuiz) {
                Text("Start Quiz")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
        }
    }
}

struct QuestionView: View {
    let question: QuizQuestion
    @Binding var selectedAnswers: Set<String>
    @Binding var fillInBlankAnswer: String
    let onNext: () -> Void
    let onBack: () -> Void
    let onSubmit: () -> Void
    let isLastQuestion: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Centered content
                VStack(spacing: 16) {
                    Text(question.question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 24)
                        .padding(.bottom, 8)

                    switch question.type {
                    case .multipleChoice:
                        MultipleChoiceView(
                            options: question.options ?? [],
                            selectedAnswers: $selectedAnswers
                        )
                    case .trueFalse:
                        TrueFalseView(selectedAnswers: $selectedAnswers)
                    case .fillInBlank:
                        FillInBlankView(answer: $fillInBlankAnswer)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .center)

                // Navigation buttons at the bottom
                HStack {
                    Button(action: onBack) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }

                    Spacer()

                    if isLastQuestion {
                        Button(action: onSubmit) {
                            HStack {
                                Text("Submit")
                                Image(systemName: "checkmark.circle.fill")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(isNextEnabled ? Color.green : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(!isNextEnabled)
                    } else {
                        Button(action: onNext) {
                            HStack {
                                Text("Next")
                                Image(systemName: "arrow.right")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(isNextEnabled ? Color.blue : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(!isNextEnabled)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private var isNextEnabled: Bool {
        switch question.type {
        case .multipleChoice:
            return !selectedAnswers.isEmpty
        case .trueFalse:
            return !selectedAnswers.isEmpty
        case .fillInBlank:
            return !fillInBlankAnswer.isEmpty
        }
    }
}

struct ResultsView: View {
    let questions: [QuizQuestion]
    let userAnswers: [Int: Any]
    let onShare: () -> Void
    
    var correctCount: Int {
        var count = 0
        for (index, question) in questions.enumerated() {
            if let userAnswer = userAnswers[index], question.isCorrect(userAnswer: userAnswer) {
                count += 1
            }
        }
        return count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Quiz Results")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("You got \(correctCount) out of \(questions.count) questions correct")
                    .font(.title2)
                    .padding(.bottom)
                
                ForEach(0..<questions.count, id: \.self) { index in
                    QuizResultQuestionView(
                        question: questions[index],
                        userAnswer: userAnswers[index]
                    )
                }
                
                HStack {
                    Spacer()
                    Button(action: onShare) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.trailing, 24)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct QuizResultQuestionView: View {
    let question: QuizQuestion
    let userAnswer: Any?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.question)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            
            switch question.type {
            case .multipleChoice:
                ForEach(question.options ?? [], id: \.self) { option in
                    let isSelected = (userAnswer as? Set<String>)?.contains(option) ?? false
                    let isCorrect = question.correctAnswers?.contains(option) ?? false
                    let userCorrect = question.isCorrect(userAnswer: userAnswer as Any)
                    
                    HStack {
                        Text(option)
                            .foregroundColor(.primary)
                        Spacer()
                        if isSelected {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        } else if isCorrect {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                userCorrect
                                    ? (isSelected && isCorrect ? Color.green : Color.clear)
                                    : (isSelected && !isCorrect ? Color.red : (isCorrect ? Color.green : Color.clear)),
                                lineWidth: 3
                            )
                    )
                }
            case .trueFalse:
                ForEach(["True", "False"], id: \.self) { option in
                    let isSelected = (userAnswer as? Set<String>)?.contains(option) ?? false
                    let isCorrect = (question.correctAnswer as? Bool) == (option == "True")
                    let userCorrect = question.isCorrect(userAnswer: userAnswer as Any)
                    
                    HStack {
                        Text(option)
                            .foregroundColor(.primary)
                        Spacer()
                        if isSelected {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        } else if isCorrect {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                userCorrect
                                    ? (isSelected && isCorrect ? Color.green : Color.clear)
                                    : (isSelected && !isCorrect ? Color.red : (isCorrect ? Color.green : Color.clear)),
                                lineWidth: 3
                            )
                    )
                }
            case .fillInBlank:
                let userText = (userAnswer as? String) ?? ""
                let correctText = (question.correctAnswer as? String) ?? ""
                let isCorrect = question.isCorrect(userAnswer: userAnswer as Any)
                HStack {
                    Text("Your answer: \(userText)")
                        .foregroundColor(isCorrect ? .green : .red)
                    Spacer()
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isCorrect ? Color.green : Color.red, lineWidth: 3)
                )
                if !isCorrect {
                    Text("Correct answer: \(correctText)")
                        .foregroundColor(.green)
                }
            }
            if let explanation = question.explanation {
                FoldableDescription(text: explanation)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct FoldableDescription: View {
    let text: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation { isExpanded.toggle() }
            }) {
                HStack {
                    Text("Description")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.subheadline)
                    Spacer()
                }
            }
            if isExpanded {
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 2)
                    .transition(.opacity)
            }
        }
        .padding(.top, 4)
    }
}

struct MultipleChoiceView: View {
    let options: [String]
    @Binding var selectedAnswers: Set<String>
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selectedAnswers.contains(option) {
                        selectedAnswers.remove(option)
                    } else {
                        selectedAnswers.insert(option)
                    }
                }) {
                    HStack {
                        Text(option)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: selectedAnswers.contains(option) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedAnswers.contains(option) ? .blue : .gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct TrueFalseView: View {
    @Binding var selectedAnswers: Set<String>
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                selectedAnswers = ["True"]
            }) {
                HStack {
                    Text("True")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: selectedAnswers.contains("True") ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedAnswers.contains("True") ? .blue : .gray)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(25)
            }
            
            Button(action: {
                selectedAnswers = ["False"]
            }) {
                HStack {
                    Text("False")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: selectedAnswers.contains("False") ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedAnswers.contains("False") ? .blue : .gray)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(25)
            }
        }
        .padding(.horizontal)
    }
}

struct FillInBlankView: View {
    @Binding var answer: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Text("Your answer:")
                    .foregroundColor(.gray)
                
                TextField("Type here", text: $answer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        isFocused = false
                    }
            }
            .padding(.horizontal)
            
            Button(action: {
                isFocused = true
            }) {
                HStack {
                    Image(systemName: "keyboard")
                    Text("Tap to type")
                }
                .foregroundColor(.blue)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            // Automatically show keyboard when view appears
            isFocused = true
        }
    }
}


#Preview {
    QuizView()
}
