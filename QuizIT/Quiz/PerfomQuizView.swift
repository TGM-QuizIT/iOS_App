//
//  PerfomQuizView.swift
//  QuizIT
//
//  Created by Marius on 05.11.24.
//

import SwiftUI

struct PerfomQuizView: View {
    @State private var selectedAnswerIndices: Set<Int> = []
    @State private var selectedAnswerScale: CGFloat = 1.0
    @State private var currentQuestionIndex: Int = 0 // Aktueller Fragenindex
    @State private var progressValue: Double = 0.0 // Fortschrittswert für Animation
    @State private var showQuestionDetail: Bool = false
    
    var focusName: String
    var quiz: Quiz
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ZStack {
                    Text(focusName)
                        .font(Font.custom("Poppins-Regular", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("\(currentQuestionIndex + 1)/\(quiz.questions.count)") // Frage-Fortschritt
                            .font(Font.custom("Roboto-Regular", size: 20))
                            .foregroundStyle(.darkGrey)
                            .multilineTextAlignment(.center)
                            .padding(32)
                        Spacer()
                        
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.black)
                            .padding(32)
                    }
                }
                
                // Fortschrittsanzeige
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 15)
                    
                    ProgressView(value: progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 15)
                        .scaleEffect(x: 1, y: 3, anchor: .center)
                        .cornerRadius(20)
                        .animation(.easeInOut(duration: 0.5), value: progressValue)
                }
                .padding(.horizontal)
                .padding(.top, -20)
            }
            
            // Frage
            ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.lightGrey)
                                .frame(width: 350, height: 210)
                                .padding(20)
                            
                            Text(quiz.questions[currentQuestionIndex].questionText)
                                .font(Font.custom("Poppins-SemiBold", size: 15))
                                .frame(maxWidth: 320)
                                .lineLimit(9)
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        showQuestionDetail.toggle()
                                    }
                                }
                            
                          
                            if showQuestionDetail {
                                CustomAlertView(
                                    questionText: quiz.questions[currentQuestionIndex].questionText,
                                    isVisible: $showQuestionDetail
                                )
                            }
                        }
            
            // Antworten
            ForEach(0..<quiz.questions[currentQuestionIndex].questionAnswers.count, id: \.self) { answerIndex in
                            answerCard(
                                questionAnswerText: quiz.questions[currentQuestionIndex].questionAnswers[answerIndex],
                                isSelected: selectedAnswerIndices.contains(answerIndex),
                                scale: selectedAnswerIndices.contains(answerIndex) ? 1.1 : 1.0
                            )
                            .onTapGesture {
                                handleAnswerSelection(for: answerIndex)
                            }
                        }
            
            Spacer()
            
            // Weiter-Button
            Button(action: {
                if currentQuestionIndex < quiz.questions.count - 1 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentQuestionIndex += 1
                        if showQuestionDetail {
                            showQuestionDetail.toggle()
                        }
                        progressValue = Double(currentQuestionIndex + 1) / Double(quiz.questions.count)
                    }
                    selectedAnswerIndices.removeAll()
                } else {
                    
                    print("Quiz beendet!")
                }
            }) {
                Text(currentQuestionIndex < quiz.questions.count - 1 ? "Weiter" : "Beenden")
                    .foregroundColor(Color.darkBlue)
                    .padding()
                    .frame(minWidth: 350)
                    .frame(height: 50)
                    .background(Color.white)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 1.7)
                    )
            }
            .padding(.bottom, 35)
            
            
        }
        .onAppear {
            // Initialen Fortschrittswert setzen
            progressValue = Double(currentQuestionIndex + 1) / Double(quiz.questions.count)
        }
        
    }
}



extension PerfomQuizView {
    func handleAnswerSelection(for answerIndex: Int) {
            withAnimation(.easeInOut(duration: 0.2)) {
                let isMultipleChoice = quiz.questions[currentQuestionIndex].questionMChoice
                
                if isMultipleChoice {
                    if selectedAnswerIndices.contains(answerIndex) {
                        selectedAnswerIndices.remove(answerIndex)
                    } else {
                        selectedAnswerIndices.insert(answerIndex)
                    }
                } else {
                    if selectedAnswerIndices.contains(answerIndex) {
                        selectedAnswerIndices.remove(answerIndex)
                    } else {
                        selectedAnswerIndices = [answerIndex]
                    }
                }
            }
        }
    
    func answerCard(questionAnswerText: String, isSelected: Bool, scale: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.lightGrey, lineWidth: 1.7)
                .background(isSelected ? Color.lightBlue : Color.white)
                .cornerRadius(12)
                .frame(width: 330, height: isSelected ? 55 : 50)
                .scaleEffect(CGSize(width: 1, height: scale))
            
            HStack {
                Text(questionAnswerText)
                    .font(Font.custom("Roboto-Regular", size: 15))
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(maxWidth: 340)
                    .frame(height: isSelected ? 55 : 50)
                    .cornerRadius(12)
                    .padding(5)
            }
            
            if isSelected {
                Image("check_custom")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.leading, 250)
            }
        }
    }
}
struct CustomAlertView: View {
    var questionText: String
    @Binding var isVisible: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 300)
                .foregroundStyle(.lightGrey)
            
            VStack(spacing: 1) {
                HStack {
                    Spacer()
                   
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isVisible = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                    }
                }
                
                
                
                ScrollView {
                    Text(questionText)
                        .font(Font.custom("Poppins-SemiBold", size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
            }
            .frame(width: 350, height: 300)
            .padding()
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .transition(.opacity.combined(with: .scale)) // Ein-/Ausblendanimation
    }
}



struct LeftRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius), style: .continuous)
        return path
    }
}

#Preview {
    PerfomQuizView(focusName: "2. Weltkrieg",quiz: Quiz(questions: [Question(
        questionId: 1,
        questionText: "What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?What is the capital of France?",
        questionAnswers: ["Paris", "Berlin", "Madrid", "Rome"], questionMChoice: true
    ),
    Question(
        questionId: 2,
        questionText: "Which planet is known as the Red Planet?",
        questionAnswers: ["Mars", "Earth", "Venus", "Jupiter"], questionMChoice: false
    ),
    Question(
        questionId: 3,
        questionText: "Who wrote 'Romeo and Juliet'?",
        questionAnswers: ["William Shakespeare", "Charles Dickens", "Mark Twain", "J.K. Rowling"], questionMChoice: false
    ),
    Question(
        questionId: 4,
        questionText: "What is the chemical symbol for water?",
        questionAnswers: ["H2O", "O2", "CO2", "NaCl"], questionMChoice: false
    ),
    Question(
        questionId: 5,
        questionText: "In which year did the Titanic sink?",
        questionAnswers: ["1912", "1905", "1920", "1918"], questionMChoice: false
    )]))
}

//                HStack(spacing:0) {
//                    LeftRoundedRectangle(cornerRadius: 20)
//                            .foregroundStyle(.blue)
//                            .frame(width: 100, height: 15)
//
//                    Rectangle()
//                    .cornerRadius(20)
//                    .foregroundStyle(.lightGrey)
//                    .frame(width: 100,height: 15)
//                }

//                ProgressView(value: 0.7) // 70% Fortschritt
//                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
//                    .frame(height: 15) // Höhe des Balkens
//                    .scaleEffect(x: 1, y: 3, anchor: .center) // Höhe des blauen Balkens anpassen
//                    .padding(.horizontal)
//                    .background(
//                        Capsule() // Verwenden von Capsule für abgerundete Ecken
//                            .fill(Color.white) // Hintergrundfarbe
//                    )
//                    .clipShape(Capsule()) // Ecken mit Capsule rund machen
