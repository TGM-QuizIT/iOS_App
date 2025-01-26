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
    @State var user: [User]
    
    @Binding var showAddFriendView: Bool
    
    @State private var showAlert = false
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return user
        } else {
            return user.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            if self.loading {
                CustomLoading()
            } else {
                VStack {
                    ZStack {
                        Text("Social")
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(.black)
                        
                        // Back Button
                        HStack {
                            Spacer()
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing)
                            
                            
                        }
                        
                        
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .background(Color.white)
                    
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
                                            Image(systemName: "xmark.circle.fill")
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
                                UserCard(user: user) {
                                    // TODO: Raphi Freund hinzufügen request (user als Parameter)
                                    withAnimation {
                                        self.showAlert = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation {
                                            self.showAlert = false
                                        }
                                        self.showAddFriendView = false
                                    }
                                    
                                    
                                    
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
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .padding(.bottom, 20)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            self.loading = true
            network.fetchAllUsers() { users, error in
                if let users = users {
                    self.user = users.filter { $0.id != network.user?.id}
                } else if let error = error {
                    print(error)
                }
                self.loading = false
            }
        }
    }
}

extension AddFriendView {
    func UserCard(user: User, tapAction: @escaping () -> Void ) -> some View {
        HStack {
            ZStack {
                HStack {
                    Image("Avatar")
                    VStack(alignment: .leading) {
                        Text(user.fullName).font(
                            .custom("Poppins-SemiBold", size: 12)
                        )
                        .padding(.leading,10)
                        
                        Text(user.uClass).font(
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
        .onTapGesture {
            network.sendFriendshipRequest(id: user.id) { success, error in
                if let success = success {
                    print(success)
                    tapAction()
                    //TODO: Unterscheiden, ob Request tatsächlich gesendet wurde (success = true -> Request gesendet; success = false -> User sind bereits befreundet oder angefragt)
                } else if let error = error {
                    print(error)
                }
            }
        }
        
    }
}

#Preview {
    AddFriendView(user: dummyUser, showAddFriendView: .constant(false))
}
