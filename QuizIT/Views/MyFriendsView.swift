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
                ProgressView()
            } else {
                ZStack {
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading) {
                                Text("Deine Freunde").font(
                                    .custom("Poppins-SemiBold", size: 16)
                                )
                                .padding(.leading)
                                if !self.currentFriends.isEmpty {
                                    ForEach(currentFriends, id: \.id) { friend in
                                        NavigationLink(
                                            destination: DetailFriendView(
                                                user: friend.user2, status: 2,
                                                friend: friend),
                                            label: {
                                                CurrentFriendCard(friend: friend)
                                            }
                                        )
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                } else {
                                    Image("no_friends_placeholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }

                                Divider()
                                    .padding(10)
                                Text("Freundesanfragen").font(
                                    .custom("Poppins-SemiBold", size: 16)
                                )
                                .padding(.leading)
                                if !self.friendRequests.isEmpty {
                                    ForEach(friendRequests, id: \.id) {
                                        friend in
                                        NavigationLink(
                                            destination: DetailFriendView(
                                                user: friend.user2, status: 1),
                                            label: {
                                                FriendRequestCard(
                                                    friend: friend, actionReq: friend.actionReq ?? false)
                                            }
                                        )
                                    }
                                } else {
                                    Image("no_pending_friends_placeholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
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
                                    .shadow(
                                        color: Color.black.opacity(0.2),
                                        radius: 5, x: 0, y: 5)

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
                    .navigationDestination(isPresented: $showAddFriendView) {
                        AddFriendView()
                    }
                    .refreshable {
                        handleRequests()
                    }

                }
                .frame(width: .infinity)

            }
        }

        .onAppear {
            self.handleRequests()
        }

    }
    
    func handleRequests() {
        self.loading = true

        network.fetchFriendships {
            acceptedFriendships, pendingFriendships, reason in
            if let acceptedFriendships = acceptedFriendships,
                let pendingFriendships = pendingFriendships
            {
                self.currentFriends = acceptedFriendships
                self.friendRequests = pendingFriendships
            } else if let reason = reason {
                print(reason)
            }
        }
        self.loading = false
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

    func FriendRequestCard(friend: Friendship,actionReq: Bool) -> some View {
        ZStack {
            HStack {
                Image("Avatar")
                VStack(alignment: .leading) {
                    Text(friend.user2.fullName).font(
                        .custom("Poppins-SemiBold", size: 12)
                    )
                    .padding(.leading, 10)
                    .foregroundStyle(.black)

                    Text(friend.user2.uClass).font(
                        .custom("Roboto-Regular", size: 12)
                    )
                    .padding(.leading, 10)
                    .foregroundStyle(.darkGrey)

                }
                Spacer()
                if actionReq {
                    Image("Accept")
                        .onTapGesture {
                            self.loading = true
                            network.acceptFriendship(id: friend.id) { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    network.fetchFriendships {
                                        acceptedFriendships, pendingFriendships,
                                        reason in
                                        if let acceptedFriendships =
                                            acceptedFriendships,
                                           let pendingFriendships =
                                            pendingFriendships
                                        {
                                            self.currentFriends =
                                            acceptedFriendships
                                            self.friendRequests =
                                            pendingFriendships.filter {
                                                $0.actionReq == true
                                            }
                                        } else if let reason = reason {
                                            print(reason)
                                        }
                                    }
                                }
                            }
                            
                            self.loading = false
                        }
                    
                    Image("Decline")
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.loading = true
                            network.declineFriendship(id: friend.id) { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    network.fetchFriendships {
                                        acceptedFriendships, pendingFriendships,
                                        reason in
                                        if let acceptedFriendships =
                                            acceptedFriendships,
                                           let pendingFriendships =
                                            pendingFriendships
                                        {
                                            self.currentFriends =
                                            acceptedFriendships
                                            self.friendRequests =
                                            pendingFriendships.filter {
                                                $0.actionReq == true
                                            }
                                        } else if let reason = reason {
                                            print(reason)
                                        }
                                    }
                                }
                            }
                            self.loading = false
                        }
                }
            }
            .padding(.leading)
            .padding(.top, 16)
        }
    }
}

#Preview {
    MyFriendsView()
}
