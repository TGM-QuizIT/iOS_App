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


    var friendship: Friendship
    var lastResults: [Result]

    var body: some View {
        VStack {
            
            NavigationHeader(title: "Social") {
                dismiss()
            }
            
            Image("AvatarM")

            Text(friendship.user2.fullName).font(
                .custom("Poppins-SemiBold", size: 20))

            Text(friendship.user2.uClass).font(
                .custom("Roboto-Regular", size: 20)
            )
            .fontWeight(.medium)

            //pendingFriendButton(friendship: friendship)

            VStack(alignment: .leading) {
                HStack {
                    Text(friendship.user2.fullName + "'s Herausforderungen").font(
                        .custom("Poppins-SemiBold", size: 16)
                    )
                    .padding(.leading)
                    .padding(.top,20)
                    Spacer()
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing:-20) {
                        ForEach(lastResults, id: \.self) { result in
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
    /* TODO: Pending anpassen (kein Freundschafts-Objekt wenn keine Anfrage vorhanden ist)
    func pendingFriendButton(friendship: Friendship) -> some View {
        Button {

        } label: {
            HStack(spacing: 8) {
                Image(
                    friendship.actionReq == 0
                        ? "add_friend"
                        : friendship.pending == 1
                            ? "pending_friend"
                            : friendship.pending == 2
                                ? "check_white" : "default")
                .resizable()
                .frame(width: 15, height: 15)
                Text(
                    friendship.pending == 0
                        ? "anfreunden"
                        : friendship.pending == 1
                            ? "ausstehend"
                            : friendship.pending == 2
                                ? "befreundet" : "unbekannt"
                )
                .foregroundColor(
                    friendship.pending == 0
                        ? Color.black
                        : friendship.pending == 1
                            ? Color.black
                            : friendship.pending == 2
                                ? Color.white : Color.black
                )
                .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        friendship.pending == 0
                            ? Color.black
                            : friendship.pending == 1
                                ? Color.black
                                : friendship.pending == 2
                                    ? Color.accentColor : Color.black,
                        lineWidth: 1)
            )
            .background(
                friendship.pending == 0
                    ? Color.white
                    : friendship.pending == 1
                        ? Color.white
                        : friendship.pending == 2
                            ? Color.accentColor : Color.white
            )  // Hintergrundfarbe des Buttons
            .cornerRadius(20)
        }
    }
     */
    
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
    DetailFriendView(friendship: dummyFriendships[0], lastResults: dummyResults)
}
