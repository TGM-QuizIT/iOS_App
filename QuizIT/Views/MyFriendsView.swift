//
//  MyFriendsView.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//

import SwiftUI

struct MyFriendsView: View {

    @State private var showAddFriendView = false

    var currentFriends: [Friendship]
    var friendRequests: [Friendship]

    var body: some View {
        VStack {
            Button(action: {
                showAddFriendView.toggle()
            }) {
                Text("Freund hinzufügen").font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220,height: 40)
                    .background(Color.accentColor)
                    .cornerRadius(40)
            }
            .sheet(isPresented: $showAddFriendView) {
                AddFriendView(user: dummyUser)
            }

            VStack(alignment: .leading) {
                ForEach(currentFriends, id: \.id) { friend in
                    NavigationLink(
                        destination: DetailFriendView(
                            friendship: friend,
                            lastResults: dummyResults),
                        label: {
                            CurrentFriendCard(friend: friend)
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
                Text("Freundesanfragen").font(.custom("Poppins-SemiBold", size: 16))
                    .padding(.top, 30)
                    .padding(.leading)
                ForEach(friendRequests, id: \.id) { friend in
                    FriendRequestCard(friend: friend)
                }
                
                Spacer()

                
            }
        }
        .onAppear {
            // TODO: Raphael Freunde (currentFriends & friendRequests) laden
        }
        
    }
}

extension MyFriendsView {
    func CurrentFriendCard(friend: Friendship) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(friend.user2.fullName).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading, 10)

                    Text(friend.user2.uClass).font(
                        .custom("Roboto-Regular", size: 12)
                    )
                    .padding(.leading, 10)
                    .foregroundStyle(.darkGrey)

                }
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 16)
        }
    }

    func FriendRequestCard(friend: Friendship) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(friend.user2.fullName).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading, 10)

                    Text(friend.user2.uClass).font(
                        .custom("Roboto-Regular", size: 12)
                    )
                    .padding(.leading, 10)
                    .foregroundStyle(.darkGrey)

                }
                Spacer()

                Image("Accept")

                Image("Decline")
                    .padding(.horizontal, 10)
            }
            .padding(.leading)
            .padding(.top, 16)
        }
    }
}

#Preview {
    MyFriendsView(
        currentFriends: [
            dummyFriendships[0],
            dummyFriendships[1],
            dummyFriendships[2],
        ],
        friendRequests: [
            dummyFriendships[3],
            dummyFriendships[4],
        ]
    )
}
