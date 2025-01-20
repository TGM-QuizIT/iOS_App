//
//  SignInView.swift
//  QuizIT
//
//  Created by Marius on 17.12.24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var network: Network

    @Binding var showSignInView: Bool

    @State private var username = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {

            WelcomeText()

            TextField(
                "", text: $username,
                prompt: Text("mmuster").foregroundColor(Color.darkGrey)
            )
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.lightGrey))
            )
            .foregroundColor(.darkGrey)
            .font(.system(size: 18))
            .padding(.horizontal, 20)
            .accentColor(.gray)
            .textInputAutocapitalization(.never)

            SecureField(
                "", text: $password,
                prompt: Text("passwort").foregroundColor(Color.darkGrey)
            )
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.lightGrey))
            )
            .foregroundColor(.darkGrey)
            .font(.system(size: 18))
            .padding(.horizontal, 20)
            .accentColor(.gray)

            Divider()
                .frame(width: 343)
                .padding()

            Button(action: {
                self.errorMessage = ""
                if username.isEmpty {
                    self.errorMessage = "Username eingeben"
                } else if password.isEmpty {
                    self.errorMessage = "Passwort eingeben"
                } else {
                    self.login()
                }

            }) {
                if self.loading {
                    ZStack {
                        CustomLoading()
                            .frame(width: 150, height: 44)
                    }
                } else {
                    Text("Einloggen").font(
                        .custom("Poppins-SemiBold", size: 16)
                    )
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 150, height: 44)
                    .background(Color.accentColor)
                    .cornerRadius(40)
                    .padding(10)
                }
            }
            .disabled(loading)

            if errorMessage != "" {
                Text(self.errorMessage)
                    .font(.custom("Poppins-SemiBold", size: 12))
                    .foregroundStyle(.red)
            }

            Image("Logo_SignIn")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.top, 10)

            Image("Just_do_it")
                .resizable()
                .frame(width: 119, height: 45)
                .padding(.bottom, 90)

            Image("Copyright")
                .resizable()
                .frame(width: 68, height: 10)
                .padding(.bottom, 44)

            Spacer()

        }
    }

    private func login() {
        self.loading = true
        network.login(username: self.username, password: self.password) {
            text, success in
            if success {
                if let user = network.user {
                    if user.blocked == false {
                        UserManager.shared.saveUser(user: user)
                    }
                    else {
                        self.errorMessage = "Du bist blockiert. \nWende dich an deinen KV, um wieder freigeschalten zu werden."
                    }
                }

                self.showSignInView = false
            } else {
                if let t = text {
                    if t == "Invalid Credentials" {
                        self.errorMessage = "Ungültige Anmeldedaten"
                    } else {
                        self.errorMessage = t
                    }
                }
            }
            self.loading = false
        }

    }
}

extension SignInView {
    func WelcomeText() -> some View {
        VStack {
            HStack {
                Text("Willkommen zurück!")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .padding(.leading, 24)
                    .padding(.top, 137)

                Spacer()
            }
            HStack {
                Text("Mit TGM-Benutzer einloggen!")
                    .font(.custom("Roboto-Regular", size: 12))
                    .padding(.leading, 40)
                    .padding(.top, 24)
                    .foregroundStyle(.darkGrey)
                Spacer()
            }
        }

    }
}

//#Preview {
//    SignInView(showSignInView: true)
//}
