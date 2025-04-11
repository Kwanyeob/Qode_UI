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
    
    var body: some View {
        ZStack {
            switch quizState {
            case .start:
                StartView(startQuiz: startQuiz)
            case .question:
                if showResults {
                    ResultsView(
                        questions: questions,
                        userAnswers: userAnswers,
                        restartQuiz: restartQuiz
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
        VStack(alignment: .leading, spacing: 20) {
            Text(question.question)
                .font(.title2)
                .padding()
            
            Spacer()
            
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
            
            Spacer()
            
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
            .padding()
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
    let restartQuiz: () -> Void
    
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
                    let question = questions[index]
                    let userAnswer = userAnswers[index]
                    let isCorrect = userAnswer != nil && question.isCorrect(userAnswer: userAnswer!)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Question \(index + 1):")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isCorrect ? .green : .red)
                                .font(.title2)
                        }
                        
                        Text(question.question)
                            .font(.body)
                            .padding(.vertical, 5)
                        
                        if let userAnswer = userAnswer {
                            Text("Your answer: \(question.formatUserAnswer(userAnswer))")
                                .foregroundColor(isCorrect ? .green : .red)
                        } else {
                            Text("Your answer: No answer provided")
                                .foregroundColor(.red)
                        }
                        
                        if !isCorrect {
                            Text("Correct answer: \(question.formatCorrectAnswer())")
                                .foregroundColor(.green)
                            
                            if let explanation = question.explanation {
                                Text("Explanation: \(explanation)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.top, 2)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Button(action: restartQuiz) {
                    Text("Restart Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
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
                    .cornerRadius(10)
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
                .cornerRadius(10)
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
                .cornerRadius(10)
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

