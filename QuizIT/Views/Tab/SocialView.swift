//
//  FriendsView.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct SocialView: View {
    
    
    @State private var selectedTab = "Statistik"
    
    
    var body: some View {
        VStack {
            Text("Social").font(.custom("Poppins-SemiBold", size: 20))
                .padding(.top, 10)
            
            Picker("", selection: $selectedTab) {
                Text("Freunde").tag("Freunde")
                Text("Statistik").tag("Statistik")
                
            }
            .pickerStyle(SegmentedPickerStyle())
            .accentColor(.blue)
            .padding(.leading)
            .padding(.trailing)
            
            if selectedTab == "Freunde" {
                MyFriendsView(currentFriends: [dummyFriends[0],dummyFriends[1],dummyFriends[2]], friendRequests: [dummyFriends[3],dummyFriends[4]])
                    .padding()
            } else if selectedTab == "Statistik" {
                StatisticView(lastResults: dummyResults)
                    .padding()
            }
            
            
            Spacer()
        }
    }
}

#Preview {
    SocialView()
}
