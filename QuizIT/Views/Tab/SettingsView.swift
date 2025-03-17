//
//  SettingsView.swift
//  QuizIT
//
//  Created by Marius on 01.10.24.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var network: Network
    @Binding var showSignInView: Bool
    @State private var user: User?
    @Binding var selectedTab: Int
    
    @State private var presentDialogDelete: Bool = false
    @State private var presentDialogYear: Bool = false
    @State private var selectedYear: Int = 1
    private let years =  [1,2,3,4,5]

    var body: some View {
        VStack {
            Text("Settings").font(.custom("Poppins-SemiBold", size: 20))
                .padding(.top, 10)

            Image("AvatarM")
                .padding(8)
            if let userName = user?.fullName {
                Text(userName).font(.custom("Poppins-SemiBold", size: 20))
                    .padding(.top, 10)
                Text((user?.name ?? "schueler") + "@student.tgm.ac.at").font(
                    .custom("Poppins-Regular", size: 16)
                )
                .foregroundStyle(.darkGrey)
            } else {
                ProgressView()
            }

            SelectYearButton()
                .padding(.top, 20)

            ListButton(icon: "archivebox", title: "Kontaktiere uns")
                .padding(.top, 10)
                .onTapGesture {
                    guard let url = URL(string: "mailto:khoeher@tgm.ac.at?subject=QuizIT") else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }

            ListButton(icon: "info.circle", title: "Über uns")
                .padding(.top, 10)
                .onTapGesture {
                    guard let url = URL(string: "https://projekte.tgm.ac.at/quizit") else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }

            ListButton(
                icon: "rectangle.portrait.and.arrow.forward", title: "Abmelden"
            )
            .padding(.top, 10)
            .onTapGesture {
                UserManager.shared.deleteUser()
                showSignInView = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    selectedTab = 0
                }

            }
            ListButton(icon: "person.slash.fill", title: "Account löschen")
                .padding(.top, 10)
                .onTapGesture {
                    self.presentDialogDelete = true
                }
            Spacer()
        }
        .onAppear {
            if let loadedUser = UserManager.shared.loadUser() {
                withAnimation {
                    print("Benutzer geladen: \(loadedUser.name)")
                    self.user = loadedUser
                    self.selectedYear = loadedUser.year
                    self.showSignInView = false
                }
            } else {
                print(
                    "Kein Benutzer gefunden. Zeige Anmeldeansicht.")
            }
        }
        .sheet(isPresented: $presentDialogDelete) {
            VStack(alignment: .leading) {
                Text("Account löschen").font(Font.custom("Poppins-SemiBold", size: 16))
                    .padding(.leading)
                Text("Bist du sicher, dass du deinen Account löschen möchtest? Alle mit dem Account verknüpften Daten werden gelöscht.").font(Font.custom("Poppins-SemiBold", size: 12))
                    .padding(.horizontal)
                HStack {
                    Button("Abbrechen") {self.presentDialogDelete = false}
                        .padding()
                        .buttonStyle(.bordered)
                        .foregroundStyle(.black)
                    Spacer()
                    Button("Löschen") {
                        network.deleteUser() { error in
                            if error != nil {
                                //TODO: Fehlerbehandlung
                            } else {
                                self.presentDialogDelete = false
                                UserManager.shared.deleteUser()
                                showSignInView = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    selectedTab = 0
                                }
                            }
                        }
                    }
                        .padding()
                        .buttonStyle(.bordered)
                        .foregroundStyle(.red)
                }
            }
            .padding()
            .presentationDetents([.medium, .fraction(0.25)]) // Adjust height as needed
            .presentationDragIndicator(.visible) // Optional: Adds a drag indicator
        }
        .sheet(isPresented: $presentDialogYear) {
            VStack(alignment: .leading) {
                List {
                    Picker("Jahrgang auswählen", selection: $selectedYear) {
                        ForEach(self.years, id: \.self) { year in
                            Text("\(year)xHIT").tag(year)
                        }
                    }
                    
                }
                .pickerStyle(.inline)
                .onChange(of: selectedYear) {
                    network.editUserYear(newYear: selectedYear) { error in
                        if let error = error {
                            //TODO: Was passiert, wenn Bearbeiten des Jahres nicht möglich war
                        } else {
                            if let user = network.user {
                                self.user = user
                            }
                            self.presentDialogYear = false
                        }
                    }
                }
            }
            .presentationDetents([.medium, .fraction(0.35)])
            .presentationDragIndicator(.visible)
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
                    Text((user?.year.description ?? "0") + "xHIT").font(
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
        .onTapGesture {
            self.presentDialogYear = true
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
    SettingsView(showSignInView: .constant(false), selectedTab: .constant(3))
}
