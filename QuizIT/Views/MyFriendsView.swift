//
//  MyFriendsView.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//

import SwiftUI

struct MyFriendsView: View {
    
    var currentFriends: [Friendship]
    var friendRequests: [Friendship]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(currentFriends, id: \.id) { friendship in
                CurrentFriendCard(friendship: friendship)
            }
            Text("Freundesanfragen").font(.custom("Poppins-SemiBold", size: 16))
                .padding(.top,30)
                .padding(.leading)
            ForEach(friendRequests, id: \.id) { friendship in
                FriendRequestCard(friendship: friendship)
            }
            Spacer()
        }
    }
}

extension MyFriendsView {
    func CurrentFriendCard(friendship: Friendship) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(friendship.friendName).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading,10)
                    
                    Text(friendship.friendYear.description + "xHit").font(
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
    
    func FriendRequestCard(friendship: Friendship) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(friendship.friendName).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading,10)
                    
                    Text(friendship.friendYear.description + "xHit").font(
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
            dummyFriendships[0], dummyFriendships[1], dummyFriendships[2],
        ], friendRequests: [dummyFriendships[3], dummyFriendships[4]])
}

let dummyFriendships: [Friendship] = [
    Friendship(
        id: 1, friendId: 101, friendName: "mthaler", friendYear: 5,
        since: Date(timeIntervalSince1970: 1_676_000_000)),  // 2023-02-19
    Friendship(
        id: 2, friendId: 102, friendName: "tenzi", friendYear: 1,
        since: Date(timeIntervalSince1970: 1_580_000_000)),  // 2020-01-01
    Friendship(
        id: 3, friendId: 103, friendName: "rtarnoczi", friendYear: 5,
        since: Date(timeIntervalSince1970: 1_600_000_000)),  // 2020-09-13
    Friendship(
        id: 4, friendId: 104, friendName: "nredl", friendYear: 5,
        since: Date(timeIntervalSince1970: 1_700_000_000)),  // 2023-12-03
    Friendship(
        id: 5, friendId: 105, friendName: "mturetschek", friendYear: 5,
        since: Date()),
]
