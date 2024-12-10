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
               NavigationHeader(title: "Social") {
                   dismiss()
               }
               
               // Filtered User List
               ScrollView {
                   ForEach(filteredUsers, id: \.id) { user in
                       UserCard(user: user)
                   }
               }
               Spacer()
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
