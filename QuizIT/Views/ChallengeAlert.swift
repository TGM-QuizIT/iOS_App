//
//  ChallengeAlert.swift
//  QuizIT
//
//  Created by Marius on 20.01.25.
//

import SwiftUI

struct ChallengeAlert: View {
    
    var challenge: Challenge
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lightBlue)
                .frame(width: 300, height: 200)
            
            VStack {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(challenge.subject.name).font( 
                            .custom("Poppins-Bold", size: 20))
                        .frame(maxWidth: 92)
                        .lineLimit(1)
                        
                        Text(challenge.focus.name).font(
                            .custom("Poppins-SemiBold", size: 16))
                    }
                    .padding(.leading,50)
                    .padding(.bottom,130)

                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.black)
                        .padding(.trailing,55)
                        .padding(.bottom,160)
                        
                }
            }
        }
    }
}

#Preview {
    ChallengeAlert(challenge: dummyChallenges[0])
}
