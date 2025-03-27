//
//  AddFriendView.swift
//  QuizIT
//
//  Created by Marius on 10.12.24.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var network: Network

    @State private var searchText: String = ""
    @State private var loading = false
    @State var users: [User] = []

    @State private var showAlert = false

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter {
                $0.fullName.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        
        VStack {
            if self.loading {
                ProgressView()
            } else {
                VStack {
                    NavigationHeader(title: "Freund hinzufügen") {
                        dismiss()
                    }

                    // Suchleiste
                    HStack {
                        TextField("Suche", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if !searchText.isEmpty {
                                        Button(action: {
                                            searchText = ""
                                        }) {
                                            Image(
                                                systemName: "xmark.circle.fill"
                                            )
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 15)
                                        }
                                    }
                                }
                            )
                    }
                    .padding(.top, 8)
                    ZStack {
                        // Filtered User List
                        ScrollView {
                            ForEach(filteredUsers, id: \.id) { user in
                                NavigationLink(
                                    destination: DetailFriendView(
                                        user: user, status: 0)
                                ) {
                                    UserCard(user: user)
                                }
                            }

                        }
                        if showAlert {
                            VStack {
                                Spacer()
                                Text("Freundschaftsanfrage gesendet!")
                                    .font(.custom("Poppins-SemiBold", size: 16))
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                                    .transition(
                                        .move(edge: .bottom).combined(
                                            with: .opacity)
                                    )
                                    .padding(.bottom, 20)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }

                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.loading = true
            network.fetchAllUsers { users, error in
                if let users = users {
                    let acceptedIds = Set(network.acceptedFriendships?.map { $0.user2.id } ?? [])
                    self.users = users.filter { user in
                        return user.id != network.user?.id && !acceptedIds.contains(user.id)
                    }
                } else if let error = error {
                    //Fehlerbehandlung
                }
                self.loading = false
            }
        }

    }
}

extension AddFriendView {
    func UserCard(user: User) -> some View {
        HStack {
            ZStack {
                HStack {
                    Image("Avatar")
                    VStack(alignment: .leading) {
                        Text(user.fullName).font(
                            .custom("Poppins-SemiBold", size: 12)
                        )
                        .padding(.leading, 10)
                        .foregroundStyle(.black)

                        Text(user.uClass).font(
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
        

    }
}

#Preview {
    AddFriendView()
}
