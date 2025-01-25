//
//  MyFriendsView.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//

import SwiftUI

struct MyFriendsView: View {

    @EnvironmentObject var network: Network
    @State private var showAddFriendView = false
    @State private var loading = false

    @State var currentFriends: [Friendship] = []
    @State var friendRequests: [Friendship] = []

    var body: some View {
        VStack {
            if self.loading {
                
            } else {
                ZStack {
                    ScrollView {
                        VStack {
                            
                            
                            
                            VStack(alignment: .leading) {
                                Text("Deine Freunde").font(.custom("Poppins-SemiBold", size: 16))
                                    .padding(.leading)
                                
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
                                
                                Divider()
                                    .padding(10)
                                Text("Freundesanfragen").font(.custom("Poppins-SemiBold", size: 16))
                                    .padding(.leading)
                                ForEach(friendRequests, id: \.id) { friend in
                                    FriendRequestCard(friend: friend)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.trailing, 1)
                            .padding(.bottom, 1)
                            .onTapGesture {
                                showAddFriendView.toggle()
                            }
                        }
                    }
                    .sheet(isPresented: $showAddFriendView) {
                        AddFriendView(user: dummyUser, showAddFriendView: $showAddFriendView)
                    }
                    
                }
            }
        }

        .onAppear {
            self.loading = true
            network.fetchFriendships() { acceptedFriendships, pendingFriendships, reason in
                if let acceptedFriendships = acceptedFriendships, let pendingFriendships = pendingFriendships {
                    self.currentFriends = acceptedFriendships
                    self.friendRequests = pendingFriendships.filter { $0.actionReq == true}
                } else if let reason = reason {
                    print(reason)
                }
            }
            self.loading = false
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
    MyFriendsView()
}
