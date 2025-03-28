//
//  PerfomQuizView.swift
//  QuizIT
//
//  Created by Marius on 05.11.24.
//

import SwiftUI

struct PerformQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var network: Network

    @State private var selectedAnswerIndices: Set<Int> = []
    @State private var selectedAnswerScale: CGFloat = 1.0
    @State private var currentQuestionIndex: Int = 0
    @State private var progressValue: Double = 0.0
    @State private var showQuestionDetail: Bool = false

    @State private var showResult: Bool = false
    @State private var showAlert = false
    @State private var result: Result?

    var focus: Focus?
    var subject: Subject?
    @State var quiz: Quiz
    var quizType: QuizType
    @State var challenge: Challenge?

    var body: some View {
        NavigationStack {

            VStack {
                VStack(spacing: 0) {
                    ZStack {
                        if let focus = focus {
                            Text(focus.name)
                                .font(Font.custom("Poppins-Regular", size: 20))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        } else if let subject = subject {
                            Text(subject.name)
                                .font(Font.custom("Poppins-Regular", size: 20))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }

                        HStack {
                            Text(
                                "\(currentQuestionIndex + 1)/\(quiz.questions.count)"
                            )
                            .font(Font.custom("Roboto-Regular", size: 20))
                            .foregroundStyle(.darkGrey)
                            .multilineTextAlignment(.center)
                            .padding(32)
                            Spacer()

                            Button {
                                self.showAlert = true
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(.black)
                                    .padding(32)
                            }

                        }
                    }

                    // Fortschrittsanzeige
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 15)

                        ProgressView(value: progressValue)
                            .progressViewStyle(
                                LinearProgressViewStyle(tint: .blue)
                            )
                            .frame(height: 15)
                            .scaleEffect(x: 1, y: 3, anchor: .center)
                            .cornerRadius(20)
                            .animation(
                                .easeInOut(duration: 0.5), value: progressValue)
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

                    Text(quiz.questions[currentQuestionIndex].text)
                        .font(Font.custom("Poppins-SemiBold", size: 15))
                        .frame(maxWidth: 320)
                        .lineLimit(9)
                        .multilineTextAlignment(.center)
                    //                        .onTapGesture {
                    //                            withAnimation(.easeInOut) {
                    //                                showQuestionDetail.toggle()
                    //                            }
                    //                        }

                    if showQuestionDetail {
                        CustomAlertView(
                            questionText: quiz.questions[currentQuestionIndex]
                                .text,
                            isVisible: $showQuestionDetail
                        )
                    }
                }

                // Antworten
                ForEach(
                    0..<quiz.questions[currentQuestionIndex].options.count,
                    id: \.self
                ) { answerIndex in
                    answerCard(
                        questionAnswerText: quiz.questions[currentQuestionIndex]
                            .options[answerIndex].text,
                        isSelected: selectedAnswerIndices.contains(answerIndex),
                        scale: selectedAnswerIndices.contains(answerIndex)
                            ? 1.1 : 1.0
                    )
                    .onTapGesture {
                        // Haptisches Feedback
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.prepare()
                        generator.impactOccurred()

                        quiz.questions[currentQuestionIndex].options[
                            answerIndex
                        ].selected.toggle()
                        handleAnswerSelection(for: answerIndex)
                    }
                }

                Spacer()

                Button(action: {

                    quiz.questions[currentQuestionIndex].score =
                        calcQuestionResult(
                            question: quiz.questions[currentQuestionIndex])
                    print(quiz.questions[currentQuestionIndex].score)

                    // Haptisches Feedback
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.prepare()
                    generator.impactOccurred()

                    if currentQuestionIndex < quiz.questions.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentQuestionIndex += 1
                            //                            if showQuestionDetail {
                            //                                showQuestionDetail.toggle()
                            //                            }
                            progressValue =
                                Double(currentQuestionIndex + 1)
                                / Double(quiz.questions.count)
                        }
                        selectedAnswerIndices.removeAll()
                    } else {
                        //self.result?.score = calcQuizReult(questions: quiz.questions)
                        handleRequests()
                    }
                }) {
                    Text(
                        currentQuestionIndex < quiz.questions.count - 1
                            ? "Weiter" : "Beenden"
                    )
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
            .navigationDestination(isPresented: $showResult) {
                if let challenge = self.challenge {
                    ResultView(
                        quiz: quiz, result: self.result ?? dummyResults[0],
                        challenge: challenge)
                } else {
                    ResultView(
                        quiz: quiz, result: self.result ?? dummyResults[0])
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Initialen Fortschrittswert setzen
                progressValue =
                    Double(currentQuestionIndex + 1)
                    / Double(quiz.questions.count)
            }
            .alert(
                "Willst du das Quiz wirklich beenden?", isPresented: $showAlert
            ) {
                Button("Ja") {
                    dismiss()
                }
                Button("Nein", role: .cancel) {}
            }
        }

    }

    private func handleRequests() {
        let dispatchGroup = DispatchGroup()
        if self.quizType == .subject {
            if let subject = self.subject {
                dispatchGroup.enter()
                self.network.postSubjectResult(
                    score: calcQuizReult(questions: quiz.questions),
                    subjectId: subject.id
                ) { result, error in
                    if var result = result {
                        result.subject = self.subject
                        self.result = result
                    } else {
                        if let error = error {
                            print(error)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        } else if self.quizType == .focus {
            if let focus = self.focus {
                dispatchGroup.enter()
                self.network.postFocusResult(
                    score: calcQuizReult(questions: quiz.questions),
                    focusId: focus.id
                ) { result, error in
                    if var result = result {
                        result.focus = self.focus
                        self.result = result
                    } else {
                        if let error = error {
                            print(error)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            let anotherDispatchGroup = DispatchGroup()
            if var challenge = self.challenge {
                print("would be assigning")
                guard let rId = self.result?.id else {
                    //throw new Error missing result
                    return
                }
                anotherDispatchGroup.enter()
                network.assignResultToChallenge(
                    challengeId: challenge.id, resultId: rId
                ) { challenge, error in
                    if let challenge = challenge {
                        self.challenge = challenge
                    } else if error != nil {
                        //TODO: Fehlerbehandlung
                    }
                    anotherDispatchGroup.leave()
                }
            } else {
                print(" nope would not be assigning")
            }
            anotherDispatchGroup.notify(queue: .main) {
                print(challenge?.score1?.score ?? "nix da")
                showResult.toggle()
            }
        }
    }

}

extension PerformQuizView {
    func handleAnswerSelection(for answerIndex: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            let isMultipleChoice = quiz.questions[currentQuestionIndex].mChoice

            if isMultipleChoice {
                if selectedAnswerIndices.contains(answerIndex) {
                    selectedAnswerIndices.remove(answerIndex)
                } else {
                    selectedAnswerIndices.insert(answerIndex)
                }
            } else {
                // Reset all options for Single-Choice
                quiz.questions[currentQuestionIndex].options.indices.forEach {
                    index in
                    quiz.questions[currentQuestionIndex].options[index]
                        .selected = false
                }

                // Set the newly selected answer
                quiz.questions[currentQuestionIndex].options[answerIndex]
                    .selected = true
                selectedAnswerIndices = [answerIndex]
            }
        }
    }

    func answerCard(
        questionAnswerText: String, isSelected: Bool, scale: CGFloat
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.lightGrey, lineWidth: 1.7)
                .background(isSelected ? Color.lightBlue : Color.white)
                .cornerRadius(12)
                .frame(width: 330, height: isSelected ? 50 : 50)
                .scaleEffect(CGSize(width: 1, height: scale))

            HStack {
                Text(questionAnswerText)
                    .font(Font.custom("Roboto-Regular", size: 15))
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(maxWidth: 340, alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
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
    func calcQuestionResult(question: Question) -> Double {
        var result: Double = 0
        var questionSelected = false
        let optionValue = 1.0 / Double(question.options.count)

        for option in question.options {
            if option.selected && option.correct {
                questionSelected = true
                result += optionValue
            } else if !option.selected && !option.correct {
                result += optionValue
            } else if option.selected && !option.correct {
                questionSelected = true
                result -= optionValue
            } else if !option.selected && option.correct {
                result -= optionValue
            }
        }

        if result < 0 || !questionSelected {
            result = 0
        }
        return result
    }

    func calcQuizReult(questions: [Question]) -> Double {
        var result: Double = 0
        for question in questions {
            result += question.score
        }
        return result
    }
}
struct CustomAlertView: View {
    var questionText: String
    @Binding var isVisible: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 210)
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
                .padding(.top, -40)
                Spacer()
            }
            .frame(width: 350, height: 210)
            .padding()
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .transition(.opacity.combined(with: .scale))  // Ein-/Ausblendanimation
    }
}

struct LeftRoundedRectangle: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: rect,
            cornerSize: CGSize(width: cornerRadius, height: cornerRadius),
            style: .continuous)
        return path
    }
}
//
//#Preview {
//    PerformQuizView(
//        focus: dummyFocuses[0],
//        subject: Subject(id: 1, name: "GGP",imageAddress: ""), quiz: QuizData.shared.quiz
//    )
//
//
//}

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
