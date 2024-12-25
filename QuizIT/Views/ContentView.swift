//
//  ContentView.swift
//  QuizIT
//
//  Created by Marius on 11.09.24.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var network: Network

    var user: User?

    @State private var showSignInView = true

    var body: some View {

        ZStack {
            if self.showSignInView {
                SignInView(showSignInView: self.$showSignInView)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .onAppear {
                        if let loadedUser = UserManager.shared.loadUser() {
                            withAnimation {
                                print("Benutzer geladen: \(loadedUser.name)")
                                self.showSignInView = false
                            }
                        } else {
                            print("Kein Benutzer gefunden. Zeige Anmeldeansicht.")
                        }
                    }
            } else {
                ZStack {
                    TabView {
                        MainMenu()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        SubjectView()
                            .tabItem {
                                Label("Quiz", systemImage: "book.closed")
                            }
                        SocialView()
                            .tabItem {
                                Label(
                                    NSLocalizedString("friends", comment: ""),
                                    systemImage: "person.2")
                            }
                        SettingsView(showSignInView: $showSignInView)
                            .tabItem {
                                Label(
                                    NSLocalizedString("profile", comment: ""),
                                    systemImage: "gear")
                            }
                    }
                }
                .onAppear {
                    // TODO: Raphael User/Subject/Fächer-Req
                }
                .zIndex(0)
            }
        }
        .animation(.easeInOut, value: showSignInView) 
    }
}

#Preview {
    ContentView()
}

