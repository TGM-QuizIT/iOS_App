//
//  StatisticInfoCard.swift
//  QuizIT
//
//  Created by Marius on 11.03.25.
//

import SwiftUI

struct StatisticInfoCard: View {
    var body: some View {
        ZStack {
            Color.lightGrey.ignoresSafeArea(.all)
            VStack(spacing: 16) {
                Text("Statistik Info")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    StatisticRow(icon: "trophy.fill", title: "Challenges", description: "Prozentsatz der gewonnenen Herausforderungen.")
                    
                    StatisticRow(icon: "graduationcap.fill", title: "TGM -Level", description: "Platzierung im Vergleich zu anderen Schüler:innen.")
                    
                    StatisticRow(icon: "flag.checkered.2.crossed", title: "Score", description: "Durchschnittsscore deiner abgeschlossenen Quizze.")
                    
                }
                .padding(5)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

struct StatisticRow: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .frame(width: 30, height: 30, alignment: .top)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    StatisticInfoCard()
}
