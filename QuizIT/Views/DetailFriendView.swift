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
    var challenges: [Result] = dummyResults

    var body: some View {
        VStack {
            
            NavigationHeader(title: "Social") {
                dismiss()
            }
            
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

            VStack(alignment: .leading) {
                HStack {
                    Text(user.fullName + "'s Herausforderungen").font(
                        .custom("Poppins-SemiBold", size: 16)
                    )
                    .padding(.leading)
                    .padding(.top,20)
                    Spacer()
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing:-20) {
                        ForEach(self.challenges, id: \.self) { result in
                            ResultCard(result: result)
                            
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
                StatisticCard()
                
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
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
    
    private func ResultCard(result: Result) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.base)
                    .frame(width: 169, height: 129)
                   // .shadow(radius: 5)
                    .padding()
                
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.lightBlue)
                            .frame(width: 169, height: 65)
                            .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
                            .padding()
                            .padding(.top, -43)
                        
                        URLImage(URL(string:result.focus?.imageAddress ?? "")!) { image in
                            image
                                .resizable()
                                .frame(width: 169, height: 65)
                                .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 20))
                                .padding(.top, -43)
                        }
                    }
                    
                    VStack(alignment: .center) {
                        Text(result.focus?.name ?? "")
                            .font(Font.custom("Poppins-SemiBold", size: 11))
                            .padding(.top, -10)
                        // Fortschrittsanzeige
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.lightBlue)
                                .frame(width: 143.28, height: 16) // Erhöhte Höhe
                            
                            ProgressView(value: result.score / 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: result.score>=40 ? .blue : .red))
                                .frame(width: 143.28, height: 50)
                                .scaleEffect(x: 1, y: 4, anchor: .center)
                                .cornerRadius(20)
                                .animation(.easeInOut(duration: 0.5), value: 0.2 / 100)
                            

                            Text(result.score.description + "%")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(result.score>=40 ? .white : .black)
                        }
                        .padding(.top,-15)



                        
                    }
                }
                Spacer()
            }
    }
    private func StatisticCard() -> some View {
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
                    
                    Text("Punkte")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("540")
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
                    
                    Text("Platz")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("#1540")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()
                
                
                Divider()
                    .frame(width: 10,height: 60)
                    .foregroundStyle(.black)
                
                VStack {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                    
                    Text("Score")
                        .font(.title3)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Text("79%")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding()
            }
            .padding(10)
        }
    }
}

#Preview {
    DetailFriendView(user: dummyUser[0], status: 0)
}
