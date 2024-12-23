//
//  SignInView.swift
//  QuizIT
//
//  Created by Marius on 17.12.24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var network: Network

    @State private var email = ""
    @State private var password = ""
    @State private var loading = false

    var body: some View {
        VStack {

            WelcomeText()

            TextField(
                "", text: $email,
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
                print("pressed")
                login()
            }) {
                Text("Einloggen").font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 150,height: 44)
                    .background(Color.accentColor)
                    .cornerRadius(40)
                    .padding(10)
                if self.loading {
                    ProgressView()
                }
            }
            .disabled(loading)
            
            Image("Logo_SignIn")
                .resizable()
                .frame(width: 100,height:100)
                .padding(.top,10)
            
            Image("Just_do_it")
                .resizable()
                .frame(width: 119,height:45)
                .padding(.bottom,90)
            
            Image("Copyright")
                .resizable()
                .frame(width: 68,height:10)
                .padding(.bottom,44)

            Spacer()

        }
    }
    
    private func login() {
        self.loading = true
        network.login(username:self.email, password: self.password) { text, success in
            if success {
                //TODO: was passiert nach erfolgreichem Login??
            }
            else {
                if let t = text {
                    //TODO: was passiert nach fehlerhaftem Login??
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

#Preview {
    SignInView()
}
