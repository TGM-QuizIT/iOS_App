//
//  FocusDetailView.swift
//  QuizIT
//
//  Created by Marius on 20.01.25.
//

import SwiftUI

struct QuizHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var network: Network
    @EnvironmentObject var quizData: QuizData

    var focus: Focus?
    var subject: Subject?

    @State private var results: [Result] = []
    @State private var openChallenges: [Challenge] = []
    @State private var finishedChallenges: [Challenge] = []

    

    @State private var questions: [Question] = []
    @State private var selectedFocus: Focus?
    var quizType: Int

    @State private var errorMsg: String = ""
    @State private var loading = false

    var body: some View {
        VStack {
            if self.loading {
                CustomLoading()
            } else {
                ZStack {
                    VStack {
                        NavigationHeader(
                            title: focus?.name ?? subject?.name ?? ""
                        ) {
                            dismiss()
                        }
                        ScrollView {
                            HStack {
                                Text("Offene Herausforderungen").font(
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
                            if !openChallenges.isEmpty {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(self.openChallenges, id: \.self)
                                        {
                                            challenge in
                                            OpenChallengeCard(
                                                challenge: challenge)
                                        }
                                    }
                                    .padding(.leading, 20)

                                }
                                .scrollIndicators(.hidden)
                            } else {
                                VStack {
                                    Text(
                                        "Du hast noch keine Herausforderungen!"
                                    )
                                    .font(.custom("Poppins-SemiBold", size: 16))
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.darkGrey)

                                }
                                .frame(height: 129)
                            }

                            HStack {
                                Text("Herausforderungen Historie").font(
                                    .custom("Poppins-SemiBold", size: 16)
                                )
                                .padding(.leading, 20)
                                Spacer()
                            }
                            if !finishedChallenges.isEmpty {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(
                                            self.finishedChallenges, id: \.self
                                        ) {
                                            challenge in
                                            FinishedChallengeCard(
                                                challenge: challenge)
                                        }
                                    }
                                    .padding(.leading, 20)

                                }
                                .scrollIndicators(.hidden)
                            } else {
                                VStack {
                                    Text(
                                        "Du hast noch keine Herausforderungen!"
                                    )
                                    .font(.custom("Poppins-SemiBold", size: 16))
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.darkGrey)

                                }
                                .frame(height: 129)
                            }

                            HStack {
                                Text("Deine Resultate").font(
                                    .custom("Poppins-SemiBold", size: 16)
                                )
                                .padding(.leading, 20)
                                Spacer()
                            }
                            if self.errorMsg == "" {
                                VStack {
                                    ForEach(
                                        Array(self.results.enumerated()),
                                        id: \.1
                                    ) {
                                        index, result in
                                        QuizHistory(
                                            result: result, place: index + 1)
                                    }
                                }
                                .scrollIndicators(.hidden)

                            } else {
                                VStack {
//                                    Image("error")
//                                        .resizable()
//                                        .frame(width: 270)
//                                    Text(errorMsg)
//                                        .font(
//                                            .custom(
//                                                "Poppins-SemiBold", size: 16)
//                                        )
//                                        .padding()
//                                        .multilineTextAlignment(.center)
//                                        .foregroundStyle(.darkGrey)
                                Image("no_results_placeholder")

                                }
                                .frame(
                                    height: UIScreen.main.bounds.height * 0.37)
                            }

                        }
                        Spacer()

                    }
                    .padding(.bottom,70)
                    VStack {
                        Spacer()
                        Button {
                            self.loading = true
                            if let focus = focus {
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
                                                quizData.questions = questions
                                                quizData.showQuiz = true
                                            }
                                        }
                                    }
                                }
                            } else if let subject = subject {
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
                                                quizData.questions = questions
                                                quizData.showQuiz = true
                                            }
                                        }
                                    }
                                }
                            } else {
                                print("Fehler beim Laden der Fragen.")
                            }
                            self.loading = false
                        } label: {
                            if loading {
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
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
               

            }

        }
        .onAppear {
            self.loading = true
            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            network.fetchResults(fId: self.focus?.id, sId: self.subject?.id, amount: nil) { results, error in
                if let error = error {
                    self.errorMsg = "Deine Resultate konnten nicht geladen werden. Versuche es später erneut."
                } else {
                    if let results = results {
                        self.results = results.sorted { $0.score > $1.score }
                    }
                }
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            guard let subjectId = subject?.id ?? focus?.subjectId else {
                self.errorMsg = "Es wurde keine ID gefunden."
                return
            }

            network.fetchSubjectChallenges(subjectId: subjectId) { openChallenges, finishedChallenges, error in
                if let openChallenges = openChallenges, let finishedChallenges = finishedChallenges {
                    self.openChallenges = openChallenges
                    self.finishedChallenges = finishedChallenges
                } else if let error = error {
                    self.errorMsg = "Es konnten keine Challenges gefunden werden."
                }
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) {
                self.loading = false
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

extension QuizHistoryView {
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
                    .padding(.leading, 55)
                }

                Spacer()
                Text(result.date.formatted(date: .abbreviated, time: .omitted))
                    .font(
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
    private func OpenChallengeCard(challenge: Challenge) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 200, height: 129)

            // .shadow(radius: 5)

            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.lightBlue)
                        .frame(width: 200, height: 75)
                        .clipShape(
                            CustomCorners(
                                corners: [.topLeft, .topRight], radius: 20)
                        )
                }

                Text(
                    challenge.focus?.name ?? challenge.subject?.name
                        ?? "Unbekannt"
                )
                .font(Font.custom("Poppins-SemiBold", size: 11))
                .padding(.bottom, 2)

                // Fortschrittsanzeige

                ZStack(alignment: .leading) {
                    // Hintergrund der Fortschrittsanzeige
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.7), lineWidth: 2)
                        .frame(height: 23)

                    // Fortschrittsfüllung
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue).opacity(0.7)
                        .frame(
                            width: CGFloat(challenge.score2?.score ?? 0) * 1.5, //TODO: Sinnvollen Standardwert bzw. Optional Binding
                            height: 23
                        )  // Breite basierend auf % (max. 250px)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: challenge.score2?.score ?? 0) //TODO: Sinnvollen Standardwert bzw. Optional Binding

                    // Prozentzahl in der Mitte
                    Text("\(challenge.score2?.score.description ?? "0")%")
                        .foregroundColor(.darkGrey)
                        .bold()
                        .frame(width: 150, height: 40)
                        .background(Color.clear)
                }
                .frame(width: 125, height: 30)

            }
            .padding(.bottom, 40)

            Image("AvatarBackground")
                .resizable()
                .frame(width: 47, height: 47)
                .padding(.trailing, 120)
                .padding(.bottom, 120)
                .padding(.top, 9)

            VStack(alignment: .leading) {
                Text(challenge.friendship.user2.fullName)
                    .font(.custom("Poppins-SemiBold", size: 15))
                    .frame(width: 120, alignment: .leading)
                    .lineLimit(1)
                    .padding(.top, 10)
                    .padding(.leading, 95)

                Text(challenge.friendship.user2.uClass)
                    .font(.custom("Poppins-Regular", size: 12))
                    .frame(width: 140, alignment: .leading)
                    .padding(.leading, 100)
            }
            .padding(.bottom, 120)
        }
        .padding(.leading, -30)
    }
    func FinishedChallengeCard(challenge: Challenge) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 250, height: 170)

            // .shadow(radius: 5)

            ZStack {
                Rectangle()
                    .fill(Color.lightBlue)
                    .frame(width: 250, height: 105)
                    .clipShape(
                        CustomCorners(
                            corners: [.topLeft, .topRight], radius: 20)
                    )

            }
            .padding(.bottom, 70)
            ZStack {
                HStack {
                    // Kreis
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 9)
                            .opacity(0.2)
                            .foregroundColor(.darkBlue)

                        Circle()
                            .trim(
                                from: 0.0,
                                to: CGFloat((challenge.score1?.score ?? 0) / 100) //TODO: Sinnvollen Standardwert bzw. Optional Binding
                            )
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: 9, lineCap: .round)
                            )
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(-90))

                        Text("\(Int(challenge.score1?.score ?? 0))%").font( //TODO: Sinnvollen Standardwert bzw. Optional Binding
                            .custom("Roboto-Bold", size: 16)
                        )
                        .bold()
                    }
                    .frame(width: 60, height: 60)
                    .padding(.leading, 20)
                    Spacer()
                    Image("trophy_gold")
                        .resizable()
                        .frame(width: 46, height: 46)
                    Spacer()
                    // Kreis
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 9)
                            .opacity(0.2)
                            .foregroundColor(.enemyRed)

                        Circle()
                            .trim(
                                from: 0.0,
                                to: CGFloat(
                                    ((challenge.score2?.score ?? 0) / 100))
                            )
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: 9, lineCap: .round)
                            )
                            .foregroundColor(.enemyRed)
                            .rotationEffect(.degrees(-90))

                        Text("\(Int(challenge.score2?.score ?? 0))%").font(
                            .custom("Roboto-Bold", size: 16)
                        )
                        .bold()
                    }
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 20)

                }
                .padding(.bottom, 70)

                Image("AvatarBackground")
                    .resizable()
                    .frame(width: 47, height: 47)
                    .padding(.trailing, 160)
                    .padding(.bottom, 120)
                    .padding(.top, 215)

                VStack(alignment: .center) {
                    Text(challenge.friendship.user2.fullName)
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .frame(width: 120, alignment: .center)
                        .lineLimit(1)
                        .padding(.top, 10)
                        .padding(.leading, 50)
                    if let focus = challenge.focus {
                        Text(focus.name)
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .frame(width: 140, alignment: .center)
                            .padding(.leading, 50)
                    } else if let subject = challenge.subject {
                        Text(subject.name)
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .frame(width: 140, alignment: .center)
                            .padding(.leading, 50)
                    }
                }
                .padding(.top, 90)

            }
            .frame(width: 250, height: 170)

        }

    }
}

#Preview {
    QuizHistoryView(quizType: 0)
}
