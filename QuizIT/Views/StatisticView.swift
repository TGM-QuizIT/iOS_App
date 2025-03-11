//
//  StatisticView.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//

import Charts
import SwiftUI
import URLImage

struct StatisticView: View {

    @EnvironmentObject var network: Network

    @State private var lastResults: [Result] = []
    @State private var stats: Statistic? = nil
    @State private var challenges: [Challenge] = []

    @State private var loading = false
    @State private var error = false
    @State private var showStatisticInfoCard = false

    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else if error {
                //TODO: Display error
            } else {
                ScrollView {
                    VStack {
                        if let stats = self.stats {
                            StatisticCard(stats: stats)
                                .onTapGesture {
                                    self.showStatisticInfoCard = true
                                }
                        }

                        HStack {
                            Text("Quiz Verlauf").font(
                                .custom("Poppins-SemiBold", size: 16)
                            )
                            .padding(.leading, 20)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            HStack(spacing: -20) {
                                ForEach(lastResults, id: \.self) { result in
                                    ResultCard(result: result)

                                }
                            }
                        }
                        .scrollIndicators(.hidden)

                        // StatisticChartView(lastResults: lastResults)

                    }
                }
            }
        }
        .onAppear {
         handleRequests()
        }
        .sheet(isPresented: $showStatisticInfoCard) {
            StatisticInfoCard()
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }

    }

    private func handleRequests() {
        self.loading = true
        self.error = false

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        network.fetchResults(fId: nil, sId: nil, amount: 7) { results, error in
            if let results = results {
                self.lastResults = results
            } else if error != nil {
                self.error = true
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        guard let id = network.user?.id else {
            //throw UserError.missingUserObject(message: "The ID is null.")
            return
        }
        network.fetchUserStats(id: id) { stats, error in
            if let stats = stats {
                self.stats = stats
            } else if error != nil {
                self.error = true
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        network.fetchDoneChallenges { challenges, error in
            if let challenges = challenges {
                self.challenges = challenges
            } else if error != nil {
                self.error = true
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.loading = false
        }
    }
}

extension StatisticView {
    private func StatisticCard(stats: Statistic) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentColor)
                .frame(width: 370, height: 110)
                .shadow(radius: 5)
                .padding()
            HStack {
                VStack {
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)

                    Text("Challenges")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("\(Int(stats.winRate)) %")
                        .font(.title3)
                        .foregroundStyle(Color.white)

                }
                .padding()

                Divider()
                    .frame(width: 10, height: 60)
                    .foregroundStyle(.black)

                VStack {
                    Image(systemName: "graduationcap.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)

                    Text("Level")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text(stats.rank == -1 ? "-" : "\(stats.rank)")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()

                Divider()
                    .frame(width: 10, height: 60)
                    .foregroundStyle(.black)

                VStack {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)

                    Text("Score")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("\(Int(stats.average)) %")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()
            }
            .padding(10)
        }
    }
    private func ResultCard(result: Result) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 169, height: 129)
                .padding()

            // FOCUS
            if let focus = result.focus {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.lightBlue)
                            .frame(width: 169, height: 65)
                            .clipShape(
                                CustomCorners(corners: [.topLeft, .topRight], radius: 20)
                            )
                            .padding()
                            .padding(.top, -43)

                        URLImage(URL(string: focus.imageAddress)!) {
                            EmptyView()
                        } inProgress: { _ in
                            CustomLoading()
                        } failure: { error, retry in
                            VStack {
                                Text(error.localizedDescription)
                                Button("Retry", action: retry)
                            }
                        } content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 60) // 2:1 Verhältnis
                                .clipped()
                                .cornerRadius(10)
                                .padding(.top, -40)
                        }
                    }

                    VStack(alignment: .center) {
                        Text(focus.name)
                            .font(Font.custom("Poppins-SemiBold", size: 11))
                            .padding(.top, -10)

                        ProgressBar(score: Int(result.score))
                    }
                }

            // SUBJECT
            } else if let subject = result.subject {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.lightBlue)
                            .frame(width: 169, height: 65)
                            .clipShape(
                                CustomCorners(corners: [.topLeft, .topRight], radius: 20)
                            )
                            .padding()
                            .padding(.top, -43)

                        URLImage(URL(string: subject.imageAddress)!) {
                            EmptyView()
                        } inProgress: { _ in
                            CustomLoading()
                        } failure: { error, retry in
                            VStack {
                                Text(error.localizedDescription)
                                Button("Retry", action: retry)
                            }
                        } content: { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 60) // 2:1 Verhältnis
                                .clipped()
                                .cornerRadius(10)
                                .padding(.top, -40)
                        }
                    }

                    VStack(alignment: .center) {
                        Text(subject.name)
                            .font(Font.custom("Poppins-SemiBold", size: 11))
                            .padding(.top, -10)

                        ProgressBar(score: Int(result.score))
                    }
                }
            }

            Spacer()
        }
    }
    private func ProgressBar(score: Int) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.7), lineWidth: 2)
                .frame(height: 23)

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.7))
                .frame(width: CGFloat(score) * 1.5, height: 23) // Dynamisch nach Score
                .animation(.easeInOut(duration: 0.3), value: score)

            Text("\(score)%")
                .foregroundColor(.darkGrey)
                .bold()
                .frame(width: 150, height: 40)
                .background(Color.clear)
        }
        .frame(width: 125, height: 30)
    }



}

#Preview {
    StatisticView()
}

struct StatisticChartView: View {
    var lastResults: [Result]

    var body: some View {
        VStack {
            Text("Ergebnisse im Überblick")
                .font(.custom("Poppins-SemiBold", size: 16))
                .padding(.leading)

            Chart(lastResults) { result in
                BarMark(
                    x: .value("Fokus", result.focus?.name ?? ""),
                    y: .value("Punkte", result.score)
                )
                .foregroundStyle(result.score >= 50 ? Color.blue : Color.red)  // Farbliche Unterscheidung basierend auf dem Score
                .cornerRadius(8)  // Abrunden der Ecken des Balkens
                .annotation(position: .top) {
                    Text("\(Int(result.score))")  // Zeigt die Punktzahl oberhalb des Balkens an
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .frame(height: 300)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))  // Hintergrundfarbe für das Diagramm
            .cornerRadius(12)
            .shadow(radius: 5)  // Schattierung für das Diagramm
            .padding(.top, 16)

        }
    }
    
}
