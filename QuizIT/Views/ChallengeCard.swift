//
//  ChallengeCard.swift
//  QuizIT
//
//  Created by Marius on 31.01.25.
//

import SwiftUI

struct ChallengeCard: View {
    
    var challenge: Challenge
    
    var body: some View {
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
                    Text("challenge.focus.name") //TODO: RAPHI OPTIONAL WRAP
                        .font(Font.custom("Poppins-SemiBold", size: 11))
                        .padding(.top, -10)
                    // Fortschrittsanzeige
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.lightBlue)
                            .frame(width: 143.28, height: 16)
                        
                        /*
                        ProgressView(value: challenge.score1.score / 100) //TODO: RAPHI OPTIONAL WRAP
                            .progressViewStyle(
                                LinearProgressViewStyle(
                                    tint: challenge.score1.score >= 40 ? .blue : .red) //TODO: RAPHI OPTIONAL WRAP
                            )
                            .frame(width: 143.28, height: 50)
                            .scaleEffect(x: 1, y: 4, anchor: .center)
                            .cornerRadius(20)
                            .animation(
                                .easeInOut(duration: 0.5), value: 0.2 / 100)
                        Text(challenge.score1.score.description + "%") //TODO: RAPHI OPTIONAL WRAP
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(
                                challenge.score1.score >= 40 ? .white : .black)
                         */
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
    ChallengeCard(challenge: dummyChallenges[0])
}
