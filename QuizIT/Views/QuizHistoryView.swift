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
    @State private var selectedChallenge: Challenge?

    

    

    @State private var questions: [Question] = []
    @State private var selectedFocus: Focus?
    var quizType: QuizType

    @State private var errorMsg: String = ""
    @State private var loading = false
    @State private var showStatisticInfoCard = false


    var body: some View {
        VStack {
            if self.loading {
                ProgressView()
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
                                            .onTapGesture {
                                                self.selectedChallenge = challenge
                                            }
                                        }
                                    }
                                    .padding(.leading, 20)

                                }
                                .scrollIndicators(.hidden)
                            } else {
                                Image("no_open_challenges_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
                                Image("no_done_challenges_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }

                            HStack {
                                Text("Deine Resultate").font(
                                    .custom("Poppins-SemiBold", size: 16)
                                )
                                .padding(.leading, 20)
                                Spacer()
                            }
                            if !self.results.isEmpty {
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
                                
                                Image("no_results_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
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
                                ProgressView()
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
            handleRequests()
        }
        .sheet(item: $selectedChallenge) { challenge in
                    ChallengeAlert(challenge: challenge)
                .presentationDetents([.height(326)])
                        .presentationDragIndicator(.visible)
                        .onDisappear() {
                            handleRequests()
                        }
                }
        .navigationBarBackButtonHidden(true)

    }
    private func handleRequests() {
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
}

struct OpenChallengeCard: View {
    var challenge: Challenge

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 200, height: 129)

            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.lightBlue)
                        .frame(width: 200, height: 75)
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
                }

                Text(challenge.focus?.name ?? challenge.subject?.name ?? "Unbekannt")
                    .font(Font.custom("Poppins-SemiBold", size: 11))
                    .padding(.bottom, 2)

                // Fortschrittsanzeige
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.7), lineWidth: 2)
                        .frame(height: 23)

                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue).opacity(0.7)
                        .frame(
                            width: CGFloat(challenge.score2?.score ?? 0) * 1.5,
                            height: 23
                        )
                        .animation(.easeInOut(duration: 0.3), value: challenge.score2?.score ?? 0)

                    Text("\(challenge.score2?.score.description ?? "0")%")
                        .foregroundColor(.darkGrey)
                        .bold()
                        .frame(width: 150, height: 40)
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
}

struct FinishedChallengeCard: View {
    var challenge: Challenge

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 250, height: 170)

            ZStack {
                Rectangle()
                    .fill(Color.lightBlue)
                    .frame(width: 250, height: 105)
                    .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
            }
            .padding(.bottom, 70)

            ZStack {
                HStack {
                    ProgressCircle(score: Int(challenge.score1?.score ?? 0), color: .darkBlue)
                        .padding(.leading, 20)

                    Spacer()
                    if challenge.score1?.score ?? 0 >= challenge.score2?.score ?? 0 {
                        Image("trophy_gold")
                            .resizable()
                            .frame(width: 46, height: 46)
                    } else {
                        Image("trophy_silver")
                            .resizable()
                            .frame(width: 46, height: 46)
                    }
                    

                    Spacer()

                    ProgressCircle(score: Int(challenge.score2?.score ?? 0), color: .enemyRed)
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

                    Text(challenge.focus?.name ?? challenge.subject?.name ?? "")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .frame(width: 140, alignment: .center)
                        .padding(.leading, 50)
                }
                .padding(.top, 90)

            }
            .frame(width: 250, height: 170)
        }
    }
}
struct ProgressCircle: View {
    var score: Int
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 9)
                .opacity(0.2)
                .foregroundColor(color)

            Circle()
                .trim(from: 0.0, to: CGFloat(score) / 100)
                .stroke(
                    style: StrokeStyle(lineWidth: 9, lineCap: .round)
                )
                .foregroundColor(color)
                .rotationEffect(.degrees(-90))

            Text("\(score)%")
                .font(.custom("Roboto-Bold", size: 16))
                .bold()
        }
        .frame(width: 60, height: 60)
    }
}


#Preview {
    QuizHistoryView(quizType: .subject)
}
