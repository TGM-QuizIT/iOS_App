//
//  ChallengeCard.swift
//  QuizIT
//
//  Created by Marius on 31.01.25.
//

import SwiftUI

struct ChallengeAlert: View {

    var challenge: Challenge
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var network: Network
    @EnvironmentObject var quizData: QuizData

    var body: some View {
        ZStack {
            Color(.lightBlue).ignoresSafeArea()

            VStack(alignment: .center) {
                if let subject = challenge.subject {
                    VStack(alignment: .center) {
                        Text(subject.name)
                            .font(.custom("Poppins-Bold", size: 20))
                    }
                    .padding(.top, 30)
                }

                if let focus = challenge.focus {
                    VStack(alignment: .center) {
                        Text("Fach")
                            .font(.custom("Poppins-Bold", size: 20))
                        Text(focus.name)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    .padding(.top, 30)
                }

                Spacer()
            }
            .frame(height: 100)
            .padding(.bottom, 230)

            HStack {
                Image("AvatarBackground")
                    .resizable()
                    .frame(width: 47, height: 47)
                    .padding(.leading, 30)

                Spacer()
                VStack {
                    Text(challenge.friendship.user2.fullName)
                        .font(.custom("Poppins-SemiBold", size: 15))
                    Text(challenge.friendship.user2.uClass)
                        .font(.custom("Poppins-Regular", size: 12))
                }
                Spacer()

                // Kreis
                ZStack {
                    Circle()
                        .stroke(lineWidth: 7)
                        .opacity(0.2)
                        .foregroundColor(.enemyRed)

                    Circle()
                        .trim(
                            from: 0.0,
                            to: CGFloat((challenge.score2?.score ?? 0) / 100)
                        )
                        .stroke(
                            style: StrokeStyle(lineWidth: 7, lineCap: .round)
                        )
                        .foregroundColor(.enemyRed)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(challenge.score2?.score ?? 0))%")
                        .font(.caption)
                        .bold()
                }
                .frame(width: 49, height: 49)
                .padding(.trailing, 44)
            }
            .padding(.bottom, 60)

            VStack(spacing: 10) {
                
                
                Button(action: {
                    if let subject = challenge.subject {
                        network.fetchSubjectQuiz(id: subject.id) {
                            questions, error in
                            if let error = error {
                                //display error
                                print(error)
                            } else {
                                if let questions = questions {
                                    if questions == [] {
                                        //no questions error
                                        print(
                                            "no questions in attribute")
                                    } else {
                                        //questions ready for next view
                                        quizData.subject = subject
                                        quizData.quizType = 0
                                        quizData.questions = questions
                                        quizData.challenge = self.challenge
                                        quizData.showQuiz = true
                                        dismiss()
                                    }
                                }
                            }
                        }
                    } else if let focus = challenge.focus {
                        network.fetchFocusQuiz(id: focus.id) {
                            questions, error in
                            if let error = error {
                                //display error
                                print(error)
                            } else {
                                if let questions = questions {
                                    if questions == [] {
                                        //no questions error
                                        print(
                                            "no questions in attribute")
                                    } else {
                                        //questions ready for next view
                                        quizData.focus = focus
                                        quizData.quizType = 1
                                        quizData.questions = questions
                                        quizData.challenge = self.challenge
                                        quizData.showQuiz = true
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                }) {
                    HStack {
                        Text("Annehmen")
                            .font(.custom("Roboto-Bold", size: 15))
                            .foregroundColor(.black)

                        Image("check_custom")
                            .resizable()
                            .frame(width: 17, height: 17)
                    }
                    .frame(minWidth: 200,minHeight: 25)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                Button(action: {
                    network.deleteChallenge(challengeId: self.challenge.id) { error in
                        if error != nil {
                            //TODO: Fehlerbehandlung
                        } else {
                            dismiss()
                        }
                    }
                }) {
                    HStack {
                        Text("Ablehnen")
                            .font(.custom("Roboto-Bold", size: 15))
                            .foregroundColor(.black)

                        Image("xmark_custom")
                            .resizable()
                            .frame(width: 21, height: 21)
                    }
                    .frame(minWidth: 200,minHeight: 25)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 150)
        }
    }
}

#Preview {
    ChallengeAlert(challenge: dummyChallenges[0])
}
