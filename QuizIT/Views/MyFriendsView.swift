//
//  MyFriendsView.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//

import SwiftUI

struct MyFriendsView: View {
    
    var currentFriends: [Friend]
    var friendRequests: [Friend]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(currentFriends, id: \.id) { Friend in
                CurrentFriendCard(Friend: Friend)
            }
            Text("Freundesanfragen").font(.custom("Poppins-SemiBold", size: 16))
                .padding(.top,30)
                .padding(.leading)
            ForEach(friendRequests, id: \.id) { Friend in
                FriendRequestCard(friend: Friend)
            }
            Spacer()
        }
    }
}

extension MyFriendsView {
    func CurrentFriendCard(Friend: Friend) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(Friend.name).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading,10)
                    
                    Text(Friend.year.description + "xHit").font(
                        .custom("Roboto-Regular", size: 12)
                    )
                    .padding(.leading,10)
                    .foregroundStyle(.darkGrey)
                    
                }
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 16)
        }
    }
    
    func FriendRequestCard(friend: Friend) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(friend.name).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading,10)
                    
                    Text(friend.year.description + "xHit").font(
                        .custom("Roboto-Regular", size: 12)
                    )
                    .padding(.leading,10)
                    .foregroundStyle(.darkGrey)
                    
                }
                Spacer()
                
                Image("Accept")
                    
                
                Image("Decline")
                    .padding(.leading,10)
            }
            .padding(.leading)
            .padding(.top, 16)
        }
    }
}

#Preview {
    MyFriendsView(
        currentFriends: [
            dummyFriends[0], dummyFriends[1], dummyFriends[2],
        ], friendRequests: [dummyFriends[3], dummyFriends[4]])
}


