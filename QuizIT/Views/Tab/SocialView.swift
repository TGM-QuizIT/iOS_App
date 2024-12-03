//
//  FriendsView.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct SocialView: View {
    
    
    @State private var selectedTab = "Freunde"
    
    
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
                MyFriendsView(currentFriends: [dummyFriendships[0],dummyFriendships[1],dummyFriendships[2]], friendRequests: [dummyFriendships[3],dummyFriendships[4]])
                    .padding()
            } else if selectedTab == "Statistik" {
                StatisticView()
                    .padding()
            }
            
            
            Spacer()
        }
    }
}

#Preview {
    SocialView()
}
