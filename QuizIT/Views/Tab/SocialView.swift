//
//  FriendsView.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct SocialView: View {
    
    @Binding var selectedTab: String
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Social")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .padding(.top, 10)
                
                // Custom Segmented Control mit Sliding Capsule
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        // Hintergrund Kapsel die sich genau anpasst
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                            .frame(width: geometry.size.width / 2, height: geometry.size.height)
                            .offset(x: selectedTab == "Freunde" ? 0 : geometry.size.width / 2)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    }
                    
                    HStack(spacing: 0) {
                        // Freunde Button
                        Button(action: {
                            selectedTab = "Freunde"
                        }) {
                            Text("Freunde")
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(selectedTab == "Freunde" ? .white : .black)
                        }
                        
                        // Statistik Button
                        Button(action: {
                            selectedTab = "Statistik"
                        }) {
                            Text("Statistik")
                                .font(.custom("Poppins-SemiBold", size: 15))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(selectedTab == "Statistik" ? .white : .black)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
                .frame(height: 40) // Fixierte Höhe
                .padding(.horizontal, 16)
                
                // Content wechseln
                if selectedTab == "Freunde" {
                    MyFriendsView()
                        .padding()
                } else if selectedTab == "Statistik" {
                    StatisticView()
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}

//#Preview {
//    SocialView(selectedTab: "Freunde")
//}



