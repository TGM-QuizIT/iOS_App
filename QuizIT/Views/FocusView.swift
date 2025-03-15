//
//  FocusView.swift
//  QuizIT
//
//  Created by Marius on 01.11.24.
//

import SwiftUI
import URLImage

struct FocusView: View {
    @EnvironmentObject var network: Network
    @EnvironmentObject var quizData: QuizData


    var subject: Subject

    @State private var focusList: [Focus] = []
    @State private var loading = true


    @State private var loadingQuiz = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if loading {
                CustomLoading()
            } else {
                VStack(alignment: .center) {

                    NavigationHeader(title: "Schwerpunkte " + subject.name) {
                        dismiss()
                    }
                    NavigationLink(destination: QuizHistoryView(subject: subject, quizType: .subject)) {
                        AllFocusCard(subject: subject) {
                            self.loadingQuiz = true
                            network.fetchSubjectQuiz(id: subject.id) { questions, error in
                                if let error = error {
                                    //display error
                                    print(error)
                                } else {
                                    if let questions = questions {
                                        if questions == [] {
                                            //no questions error
                                            print("no questions in attribute")
                                        } else {
                                            //questions ready for next view
                                            quizData.questions = questions
                                            quizData.quizType = .subject
                                            quizData.showQuiz = true
                                        }
                                    }
                                }
                            }
                            self.loadingQuiz = false
                        }
                    }
                    

                    ForEach(focusList, id: \.self) { focus in
                        NavigationLink(
                            destination: QuizHistoryView(
                                focus: focus, quizType: .focus)
                        ) {
                            FocusCard(focus: focus) {
                                self.loadingQuiz = true
                                quizData.focus = focus
                                network.fetchFocusQuiz(id: focus.id) {
                                    questions, error in
                                    if let error = error {
                                        //display error
                                        print(error)
                                    } else {
                                        if let questions = questions {
                                            if questions == [] {
                                                //no questions error
                                                print("no questions in attribute")
                                            } else {
                                                //questions ready for next view
                                                quizData.questions = questions
                                                quizData.quizType = .focus
                                                quizData.showQuiz = true
                                            }
                                        }
                                    }
                                }
                                self.loadingQuiz = false

                            }
                        }
                        

                    }

                    Spacer()
                }
                .navigationBarBackButtonHidden(true)

            }
        }
        .onAppear {
            fetchFocus()
        }
       
    }

    private func fetchFocus() {
        self.loading = true
        network.fetchFocus(id: self.subject.id) { focus, error in
            if let focus = focus {
                self.focusList = focus
            } else if let error = error {
                //TODO: Fehlerbehandlung
                self.focusList = []
            }
        }
        self.loading = false
    }
}

extension FocusView {
    private func AllFocusCard(subject: Subject, quizAction: @escaping () -> Void) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightGrey)
                .frame(width: 347, height: 110)
                .padding(6)
            Button(action: quizAction) {
                Text("Quiz starten").font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 110, height: 30)
                    .background(Color.white)
                    .cornerRadius(40)
            }
            .padding(.top, 50)
            .padding(.trailing, 200)
            URLImage(URL(string: subject.imageAddress)!) {
                // This view is displayed before download starts
                EmptyView()
            } inProgress: { progress in
                // Display progress
                CustomLoading()
                    .padding(.leading, 210)

            } failure: { error, retry in
                // Display error and retry button
                VStack {
                    Text(error.localizedDescription)
                    Button("Retry", action: retry)
                }
            } content: { image in
                // Downloaded image
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 75)
                    .clipped()
                    .padding(.leading, 190)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(subject.name)
                        .font(Font.custom("Poppins-SemiBold", size: 16))
                        .padding(.leading, 50)
                        .foregroundStyle(.black)

                    Text("\(focusList.reduce(0) { $0 + $1.questionCount }) Fragen im Pool")
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(.black)
                        .padding(.leading, 50)
                        .padding(.bottom, 35)
                }

                Spacer()

            }
        }
    }

    private func FocusCard(focus: Focus, quizAction: @escaping () -> Void)
        -> some View
    {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightGrey)
                .frame(width: 347, height: 110)
                .padding(6)
            Button(action: quizAction) {
                if loadingQuiz {
                    CustomLoading()
                } else {
                    Text("Quiz starten").font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 110, height: 30)
                    .background(Color.white)
                    .cornerRadius(40)
                }
            }
            .padding(.top, 50)
            .padding(.trailing, 200)
            URLImage(URL(string: focus.imageAddress)!) {
                // This view is displayed before download starts
                EmptyView()
            } inProgress: { progress in
                // Display progress
                CustomLoading()
                    .padding(.leading, 210)

            } failure: { error, retry in
                // Display error and retry button
                VStack {
                    Text(error.localizedDescription)
                    Button("Retry", action: retry)
                }
            } content: { image in
                // Downloaded image
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 75)
                    .clipped()
                    .padding(.leading, 190)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(focus.name)
                        .font(Font.custom("Poppins-SemiBold", size: 16))
                        .padding(.leading, 50)
                        .foregroundStyle(.black)

                    Text(
                        focus.questionCount.codingKey.stringValue
                            + " Fragen im Pool"
                    )
                    .font(Font.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(.black)
                    .padding(.leading, 50)
                    .padding(.bottom, 35)
                }

                Spacer()

            }
        }
    }
}

#Preview {
    //FocusView(subject: dummySubjects[2])
}
