//
//  AddFriendView.swift
//  QuizIT
//
//  Created by Marius on 10.12.24.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText: String = ""
    var user: [User]
    
    var filteredUsers: [User] {
            if searchText.isEmpty {
                return user
            } else {
                return user.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
            }
        }
    
    var body: some View {
           VStack {
               ZStack {
                   // Title in der Mitte
                   Text("Social")
                       .font(.custom("Poppins-SemiBold", size: 20))
                       .foregroundColor(.black)
                   
                   // Back Button
                   HStack {
                       Spacer() // Platzhalter
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
               
               // Filtered User List
               ScrollView {
                   ForEach(filteredUsers, id: \.id) { user in
                       UserCard(user: user)
                   }
               }
               Spacer()
           }
           .onAppear {
               // TODO: Raphael Alle User laden
           }
       }
}

extension AddFriendView {
    func UserCard(user: User) -> some View {
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
}

#Preview {
    AddFriendView(user: dummyUser)
}
