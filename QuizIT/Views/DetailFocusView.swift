//
//  FocusDetailView.swift
//  QuizIT
//
//  Created by Marius on 20.01.25.
//

import SwiftUI

struct DetailFocusView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var network: Network


    var focus: Focus

    var quizHistroy: [Result]
    var challenges: [Challenge]
    
    @State private var showQuiz = false

    @State private var questions: [Question] = []
    @State private var selectedFocus: Focus?

    @State private var loadingQuiz = false

    var body: some View {
        VStack {
            NavigationHeader(title: focus.name) {
                dismiss()
            }
            HStack {
                Text("Deine Resultate").font(
                    .custom("Poppins-SemiBold", size: 16)
                )
                .padding(.leading, 20)
                Spacer()
            }

            ScrollView {
                ForEach(Array(self.quizHistroy.enumerated()), id: \.1) {
                    index, result in
                    QuizHistory(result: result, place: index + 1)
                }
            }
            .frame(height: 310)
            .scrollIndicators(.hidden)

            HStack {
                Text("Herausforderungen").font(
                    .custom("Poppins-SemiBold", size: 16)
                )
                .padding(.leading, 20)
                Spacer()
//                Text("alle anzeigen").font(
//                    .custom("Poppins-SemiBold", size: 16)
//                )
//                .padding(.trailing, 20)
            }
            .padding(.top, 16)
                ScrollView(.horizontal) {
                    HStack {
                    ForEach(self.challenges, id: \.self) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                }
            }
                .scrollIndicators(.hidden)
            
            Button {
                self.loadingQuiz = true
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
                                self.questions = questions
                                self.showQuiz = true
                            }
                        }
                    }
                }
                self.loadingQuiz = false
            } label: {
                if loadingQuiz {
                    CustomLoading()
                } else {
                    Text("Quiz starten").font(
                        .custom("Poppins-SemiBold", size: 16)
                    )
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 340, height: 50)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(10)
                }
            }
            

            Spacer()
        }
        .navigationDestination(isPresented: $showQuiz) {
            PerfomQuizView(
                focus: selectedFocus ?? dummyFocuses[0],
                subject: dummySubjects[0],
                quiz: Quiz(questions: self.questions))
        }
        .navigationBarBackButtonHidden(true)

    }
}

extension DetailFocusView {
    func QuizHistory(result: Result, place: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lightBlue)
                .frame(width: 350, height: 70)

            HStack {
                if place == 1 {
                    Image("trophy_gold")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(.leading, 44)

                } else if place == 2 {
                    Image("trophy_silver")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(.leading, 44)
                } else if place == 3 {
                    Image("trophy_bronze")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(.leading, 44)
                } else {
                    Text("#" + place.description).font(
                        .custom("Roboto-Bold", size: 20)
                    )
                    .padding(.leading, 44)
                }

                Spacer()
                Text(result.date.formatted(date: .abbreviated, time: .omitted)).font(
                    .custom("Roboto-Bold", size: 20))
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 7)
                        .opacity(0.2)
                        .foregroundColor(.blue)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(result.score / 100))
                        .stroke(
                            style: StrokeStyle(lineWidth: 7, lineCap: .round)
                        )
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(result.score))%")
                        .font(.subheadline)
                        .bold()
                }
                .frame(width: 50, height: 50)
                .padding(.trailing, 44)

            }

        }
    }
    private func ChallengeCard(challenge: Challenge) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 200, height: 129)
                // .shadow(radius: 5)
                .padding()

            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.lightBlue)
                        .frame(width: 200, height: 65)
                        .clipShape(
                            CustomCorners(
                                corners: [.topLeft, .topRight], radius: 20)
                        )
                        .padding()
                        .padding(.top, -43)

                }

                VStack(alignment: .center) {
                    Text(challenge.focus.name)
                        .font(Font.custom("Poppins-SemiBold", size: 11))
                        .padding(.top, -10)
                    // Fortschrittsanzeige
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.lightBlue)
                            .frame(width: 143.28, height: 16)

                        ProgressView(value: challenge.score1 / 100)
                            .progressViewStyle(
                                LinearProgressViewStyle(
                                    tint: challenge.score1 >= 40 ? .blue : .red)
                            )
                            .frame(width: 143.28, height: 50)
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                            .cornerRadius(20)
                            .animation(
                                .easeInOut(duration: 0.5), value: 0.2 / 100)

                        Text(challenge.score1.description + "%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(
                                challenge.score1 >= 40 ? .white : .black)
                    }
                    .padding(.top, -15)

                }
            }
            Spacer()
            Image("AvatarBackground")
                .resizable()
                .frame(width: 47, height: 47)
                .padding(.trailing, 120)
                .padding(.bottom, 100)
            VStack {
                Text(challenge.friendship.user2.fullName).font(
                    .custom("Poppins-SemiBold", size: 15))
                .frame(maxWidth: 92)
                .lineLimit(1)
                Text(challenge.friendship.user2.uClass).font(
                    .custom("Poppins-Regular", size: 12))

            }
            .padding(.bottom, 100)
            .padding(.leading, 70)
        }
    }
}

#Preview {
    DetailFocusView(focus: dummyFocuses[0], quizHistroy: dummyResults, challenges: dummyChallenges)
}
