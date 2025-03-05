//
//  MainMenu.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI
import URLImage
import URLImageStore



struct MainMenu: View {
    @EnvironmentObject var network: Network
    
    @State private var subjects: [Subject] = []
    @State private var challenges: [Challenge] = []
    @State private var stats: Statistic? = nil
    @State private var loading = false
    @State private var error = false
    @State private var selectedChallenge: Challenge?
    
    var body: some View {
        VStack {
            if loading {
                CustomLoading()
            } else if error {
                Image("internet_error_placeholder")
                    .resizable()
                    .frame(width: 280,height: 212)
            }
            else {
                NavigationStack {
                    ScrollView {
                        VStack {
                            HStack {
                                
                                Image("Logo")
                                    .resizable()
                                    .frame(width: 150, height: 80)
                                    .cornerRadius(20)
                                    .padding(.leading)
                                
                                
                                
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            VStack(spacing: 1) {
                                HStack {
                                    Text("Deine Fächer").font(Font.custom("Poppins-SemiBold", size: 16))
                                        .padding(.leading)
                                    Spacer()
                                    Text("mehr anzeigen").font(Font.custom("Poppins-SemiBold", size: 12))
                                        .padding(.trailing)
                                }
                                
                                if self.subjects != [] {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(subjects, id: \.self) { subject in
                                                NavigationLink(destination: FocusView(subject: subject)) {
                                                    SubjectCard(subject: subject)
                                                }
                                            }
                                        }
                                        .padding(.top)
                                    }
                                    .scrollIndicators(.hidden)
                                }
                                
                                else {
                                    Text("Keine Fächer verfügbar").font(Font.custom("Poppins-Semibold", size: 15))
                                        .padding(.leading)
                                }
                                HStack {
                                    Text("Herausforderungen").font(Font.custom("Poppins-SemiBold", size: 16))
                                        .padding(.leading)
                                    Spacer()
                                    Text("mehr anzeigen").font(Font.custom("Poppins-SemiBold", size: 12))
                                        .padding(.trailing)
                                }
                                
                                if self.challenges != [] {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(challenges, id: \.self) { challenge in
                                                OpenChallengeCard(challenge: challenge)
                                                    .onTapGesture {
                                                                                                            selectedChallenge = challenge
                                                                                                        }
                                            }
                                        }
                                        .padding(.top)
                                        .padding(.leading)
                                    }
                                    .scrollIndicators(.hidden)
                                } else {
                                    VStack {
                                        Text("Es konnten keine Herausforderungen gefunden werden.")
                                            .font(
                                                .custom(
                                                    "Poppins-SemiBold", size: 16)
                                            )
                                            .padding()
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(.darkGrey)
                                    }
                                    .frame(height: 200)
                                }
                                
                                
                                HStack {
                                    Text("Deine Statistiken").font(Font.custom("Poppins-SemiBold", size: 16))
                                        .padding(.leading)
                                    Spacer()
                                    Text("mehr anzeigen").font(Font.custom("Poppins-SemiBold", size: 12))
                                        .padding(.trailing)
                                }
                                if let stats = self.stats {
                                    StatisticCard(stats: stats)
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
       handleRequests()
        }
        .sheet(item: $selectedChallenge) { challenge in
                    ChallengeAlert(challenge: challenge)
                .presentationDetents([.height(326)]) // Definiert verschiedene Größen für das Bottom-Sheet
                        .presentationDragIndicator(.visible) // Zeigt den Drag-Indikator an
                }
    }
    
    private func handleRequests() {
        self.loading = true
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        network.fetchSubjects() { error in
            if let error = error {
                // TODO: Fehlerbehandlung, wenn Fächer nicht abrufbar waren#
                self.error = true
                self.loading = false
                
            } else {
                self.subjects = network.subjects ?? []
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
                // TODO: Fehlerbehandlung
            } else {
                self.stats = Statistic(avg: 0, rank: -1, winRate: 0)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        network.fetchFriendships() { accepted, pending, error in
            if error != nil {
                // TODO: Fehlerbehandlung
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        network.fetchOpenChallenges() { challenges, error in
            if let challenges = challenges {
                self.challenges = challenges.filter { $0.score1 == nil}
            } else if error != nil {
                //TODO: Fehlerbehandlung
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.loading = false
        }
    }
}

extension MainMenu {
    private func SubjectCard(subject: Subject) -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                            .frame(width: 270, height: 212)
                            .shadow(radius: 5)
                            .padding()

            
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.base)
                        .frame(width: 270, height: 107)
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))  // Apply corner radius only to top corners
                        .padding()
                        .padding(.top, -43)

                    URLImage(URL(string: subject.imageAddress)!) {
                        // This view is displayed before download starts
                        EmptyView()
                    } inProgress: { progress in
                        // Display progress
                        CustomLoading()
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
                            .frame(width: 214, height: 107)
                            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))  // Apply corner radius only to top corners
                            .padding(.top, -43)
                    }
                    
                }
                
                
                VStack(alignment: .center) {
                    Text(subject.name)
                        .font(Font.custom("Poppins-SemiBold", size: 19))
                        .foregroundStyle(.black)
                        .padding(.top, -10)
                                
                
                
                            Text("Schwerpunkte")
                                .foregroundColor(Color.darkBlue)
                                .padding()
                                .frame(minWidth: 218)
                                .frame(height: 40)
                                .background(Color.white)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 1.7)
                                      
                                )
                        .padding(.top,5)
                }
            }

            Spacer()
            
            
        }

    }
    
    private func StatisticCard(stats: Statistic) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentColor)
                .frame(width: 370, height: 110)
                .shadow(radius: 5)
                .padding()

            HStack(spacing: 0) {
                statColumn(icon: "star.fill", title: "Challenges", value: "\(Int(stats.winRate)) %")
                
                Divider()
                    .frame(height: 60)
                    .background(Color.darkGrey)

                statColumn(icon: "graduationcap.fill", title: "Level", value: stats.rank == -1 ? "-" : "\(stats.rank)")
                
                Divider()
                    .frame(height: 60)
                    .background(Color.darkGrey)

                statColumn(icon: "trophy.fill", title: "Score", value: "\(Int(stats.average)) %")
            }
            .padding(10)
        }
    }

    @ViewBuilder
    private func statColumn(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.white)
                .frame(height: 24)

            Text(title)
                .font(.headline)
                .foregroundStyle(Color.white.opacity(0.5))
                .frame(height: 18)

            Text(value)
                .font(.headline)
                .foregroundStyle(Color.white)
                .frame(height: 22)
        }
        .frame(maxWidth: .infinity, alignment: .center)
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
                    let score = Int(challenge.score2?.score ?? 50)

                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue).opacity(0.7)
                        .frame(
                            width: CGFloat(score) * 1.5,
                            height: 23
                        )
                        .animation(.easeInOut(duration: 0.3), value: score)

                    // Prozentzahl in der Mitte
                    Text("\(score)%")
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
        .frame(width: 200)
    }
        


}

#Preview {
    MainMenu()
}


