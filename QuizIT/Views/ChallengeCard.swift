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
                .fill(Color.lightBlue)
                .frame(width: 328, height: 226)
                .shadow(radius: 2)
                .padding()

            VStack(alignment: .leading) {
                if let subject = challenge.subject {
                    VStack(alignment: .leading) {
                        Text(subject.name)
                            .font(.custom("Poppins-Bold", size: 20))
                    }
                    .padding(.top, 30)
                    .padding(.leading, 30)
                }

                if let focus = challenge.focus {
                    VStack(alignment: .leading) {
                        Text("Fach")
                            .font(.custom("Poppins-Bold", size: 20))
                        Text(focus.name)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    .padding(.top, 30)
                    .padding(.leading, 30)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 180)
                    .padding(.leading, 280)
            }
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

            HStack(spacing:20) {
                Button(action: {
                            print("Button gedrückt!")
                        }) {
                            HStack {
                                Text("Ablehnen")
                                    .font(.custom("Roboto-Bold", size: 15))
                                    .foregroundColor(.black)
                                
                                Image("xmark_custom")
                                    .resizable()
                                    .frame(width: 21,height: 21)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                Button(action: {
                            print("Button gedrückt!")
                        }) {
                            HStack {
                                Text("Annehmen")
                                    .font(.custom("Roboto-Bold", size: 15))
                                    .foregroundColor(.black)
                                
                                Image("check_custom")
                                    .resizable()
                                    .frame(width: 17,height: 17)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                
            }
            .padding(.top,140)
        }
        .frame(width: 328, height: 226)
    }
}

#Preview {
    ChallengeCard(challenge: dummyChallenges[0])
}
