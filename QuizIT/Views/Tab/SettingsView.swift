//
//  SettingsView.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct SettingsView: View {

    @Binding var showSignInView: Bool

    @State var user: User
    
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            Text("Settings").font(.custom("Poppins-SemiBold", size: 20))
                .padding(.top, 10)

            Image("AvatarM")
                .padding(8)

            Text(user.fullName).font(.custom("Poppins-SemiBold", size: 20))
                .padding(.top, 10)

            Text(user.name + "@student.tgm.ac.at").font(
                .custom("Poppins-Regular", size: 16)
            )
            .foregroundStyle(.darkGrey)

            SelectYearButton()
                .padding(.top, 20)

            ListButton(icon: "archivebox", title: "Kontaktiere uns")
                .padding(.top, 10)

            ListButton(icon: "info.circle", title: "Über uns")
                .padding(.top, 10)

            ListButton(
                icon: "rectangle.portrait.and.arrow.forward", title: "Abmelden"
            )
            .padding(.top, 10)
            .onTapGesture {
                UserManager.shared.deleteUser()
                showSignInView = true
                
                selectedTab = 0
            }

            Spacer()
        }
    }
}

extension SettingsView {
    func SelectYearButton() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 343, height: 72)
                .padding(.horizontal, 20)
            HStack {
                ZStack {
                    Rectangle()
                        .fill(Color.lightBlue)
                        .frame(width: 80, height: 69)
                        .clipShape(
                            RoundedCornerShape(
                                corners: [.topLeft, .bottomLeft], radius: 15)
                        )  // Ecken angepasst
                        .padding(.horizontal, 20)
                    Image(systemName: "building.columns.fill").font(
                        .system(size: 35))
                }
                VStack(alignment: .leading) {
                    Text("Jahrgang auswählen").font(
                        .custom("Roboto-Bold", size: 15))
                    Text(user.year.description + "xHIT").font(
                        .custom("Roboto-Regular", size: 15)
                    )
                    .foregroundStyle(.darkGrey)
                }

                Spacer()
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(.darkGrey)
                .padding(.leading, 280)

        }
    }
    func ListButton(icon: String, title: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.base)
                .frame(width: 343, height: 60)
                .padding(.horizontal, 20)
            HStack {
                ZStack {
                    Rectangle()
                        .fill(Color.lightBlue)
                        .frame(width: 80, height: 60)
                        .clipShape(
                            RoundedCornerShape(
                                corners: [.topLeft, .bottomLeft], radius: 15)
                        )  // Ecken angepasst
                        .padding(.horizontal, 20)
                    Image(systemName: icon).font(
                        .system(size: 35))
                }

                Text(title).font(
                    .custom("Roboto-Bold", size: 15))

                Spacer()
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(.darkGrey)
                .padding(.leading, 280)

        }
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false), user: dummyUser[0], selectedTab: .constant(3))
}
