//
//  DetailFriendView.swift
//  QuizIT
//
//  Created by Marius on 09.12.24.
//

import SwiftUI
import URLImage

struct DetailFriendView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var network: Network


    
    var user: User
    @State var status: Int
    var friend: Friendship?
    @State var results: [Result] = []
    @State var openChallenges: [Challenge] = []
    @State var doneChallenges: [Challenge] = []
    
    @State var loading = false
    @State var stats: Statistic = Statistic(avg: 0, rank: -1, winRate: 0)
    
    @State private var selectedChallenge: Challenge?


    var body: some View {
        VStack {
            if self.loading {
                ProgressView()
            }
            else {
                VStack {
                    
                    NavigationHeader(title: "Social") {
                        dismiss()
                    }
                    ScrollView {
                        Image("AvatarM")
                        
                        Text(user.fullName).font(
                            .custom("Poppins-SemiBold", size: 20))
                        
                        Text(user.uClass).font(
                            .custom("Roboto-Regular", size: 20)
                        )
                        .fontWeight(.medium)
                        
                        pendingFriendButton(status: self.status) {
                            if(self.status == 0) {
                                network.sendFriendshipRequest(friendId: user.id) { success, error in
                                    if let success = success {
                                        if(success) {
                                            print("Freundschaftsanfrage an \(user.name) gesendet!")
                                            self.status = 1
                                        } else {
                                            print("User ist bereits befreundet")
                                        }
                                    } else if let error = error {
                                        print(error)
                                    }
                                }
                            } else if(self.status == 2) {
                                if let friend = self.friend {
                                    network.declineFriendship(id: friend.id) { error in
                                        if let error = error {
                                            print(error)
                                        } else {
                                            print("Freund: \(friend.user2.name) entfernt")
                                            self.status = 0
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        StatisticCard(stats: self.stats)

                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(user.fullName + "'s Herausforderungen").font(
                                    .custom("Poppins-SemiBold", size: 16)
                                )
                                .padding(.leading)
                                .padding(.top,20)
                                Spacer()
                            }
                            
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
                            if !self.doneChallenges.isEmpty {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(
                                            self.doneChallenges, id: \.self
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
                            
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            self.handleRequests()
        }
        .sheet(item: $selectedChallenge) { challenge in
                    ChallengeAlert(challenge: challenge)
                .presentationDetents([.height(326)])
                        .presentationDragIndicator(.visible)
                        .onDisappear {
                            self.handleRequests()
                        }
                }
        .navigationBarBackButtonHidden(true)
        
    }
    private func handleRequests() {
        self.loading = true
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        network.fetchUserStats(id: user.id) { stats, error in
            if let stats = stats {
                self.stats = stats
            } else if let error = error {
                //TODO: Fehlerbehandlung
            }
            dispatchGroup.leave()
        }
        if let friendship = self.friend {
            dispatchGroup.enter()
            network.fetchFriendshipsChallenges(friendshipId: friendship.id) { openChallenges, doneChallenges, error in
                if let openChallenges = openChallenges, let doneChallenges = doneChallenges {
                    self.openChallenges = openChallenges
                    self.doneChallenges = doneChallenges
                } else if let error = error {
                    //TODO: Fehlerbehandlung
                }
                dispatchGroup.leave()
            }
        }
        
        //Challenges einer Freundschaft fetchen
        dispatchGroup.notify(queue: .main) {
            self.loading = false
        }
    }
}

extension DetailFriendView {
    func pendingFriendButton(status: Int, clickAction: @escaping () -> Void) -> some View {
        ZStack {
            Button {
                clickAction()
            } label: {
                HStack(spacing: 8) {
                    Image(
                        status == 0
                            ? "add_friend"
                            : status == 1
                                ? "pending_friend"
                                : status == 2
                                    ? "check_white" : "default")
                    .resizable()
                    .frame(width: 15, height: 15)
                    Text(
                        status == 0
                            ? "anfreunden"
                            : status == 1
                                ? "ausstehend"
                                : status == 2
                                    ? "befreundet" : "unbekannt"
                    )
                    .foregroundColor(
                        status == 0
                            ? Color.black
                            : status == 1
                                ? Color.black
                                : status == 2
                                    ? Color.white : Color.black
                    )
                    .font(.system(size: 16, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            status == 0
                                ? Color.black
                                : status == 1
                                    ? Color.black
                                    : status == 2
                                        ? Color.accentColor : Color.black,
                            lineWidth: 1)
                )
                .background(
                    status == 0
                        ? Color.white
                        : status == 1
                            ? Color.white
                            : status == 2
                                ? Color.accentColor : Color.white
                )
                .cornerRadius(20)
            }
        }
        
    }
    private func StatisticCard(stats: Statistic) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.accentColor)
                .frame(width: 370, height: 110)
                .shadow(radius: 5)
                .padding()

            HStack(spacing: 0) { // Kein zusätzlicher Abstand zwischen den Spalten
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
                .frame(maxWidth: .infinity) // Gleichmäßige Verteilung

                Divider()
                    .frame(height: 60)
                    .background(Color.darkGrey)

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
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(height: 60)
                    .background(Color.darkGrey)

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
                .frame(maxWidth: .infinity)
            }
            .padding(10)
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
    DetailFriendView(user: dummyUser[0], status: 0)
}
